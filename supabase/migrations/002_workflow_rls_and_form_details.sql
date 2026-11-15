-- ============================================================================
-- KALĀ — Real-time organizer → student form workflow
-- Idempotent. Safe to re-run. Run in Supabase → SQL Editor AFTER 001.
-- ============================================================================

-- 1. opportunities: full detail round-trip for the student preview
ALTER TABLE public.opportunities
  ADD COLUMN IF NOT EXISTS eligibility TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS requirements JSONB NOT NULL DEFAULT '[]'::jsonb;

-- 2. form_fields: persist every question exactly as the organizer built it
ALTER TABLE public.form_fields
  ADD COLUMN IF NOT EXISTS placeholder TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS accepted_file_types JSONB NOT NULL DEFAULT '[]'::jsonb;

-- 3. Duplicate prevention: one application per student per opportunity.
--    Wrapped so pre-existing duplicates don't break idempotent re-runs.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE schemaname = 'public'
      AND indexname = 'uq_submissions_student_opportunity'
  ) THEN
    BEGIN
      CREATE UNIQUE INDEX uq_submissions_student_opportunity
        ON public.application_submissions (student_id, opportunity_id);
    EXCEPTION WHEN others THEN
      RAISE NOTICE 'Skipping unique submission index: %', SQLERRM;
    END;
  END IF;
END $$;

-- 4. Realtime publication (idempotent; also covers form_fields)
DO $$
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'events', 'opportunities', 'dynamic_forms',
    'form_fields', 'application_submissions', 'submission_answers'
  ] LOOP
    IF NOT EXISTS (
      SELECT 1 FROM pg_publication_tables
      WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = t
    ) THEN
      EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE public.%I', t);
    END IF;
  END LOOP;
END $$;

-- ============================================================================
-- Row Level Security — enables owner-scoped access:
--   • organizers can only read applications submitted to THEIR opportunities
--   • students can only read their own submissions
--   • everyone authenticated can browse published events/opportunities/forms
-- ============================================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dynamic_forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.application_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submission_answers ENABLE ROW LEVEL SECURITY;

-- users / organizations ------------------------------------------------------
DROP POLICY IF EXISTS "users_profiles_read" ON public.users;
CREATE POLICY "users_profiles_read" ON public.users
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- Sign-up writes the profile row right after registering.
DROP POLICY IF EXISTS "users_profiles_self_insert" ON public.users;
CREATE POLICY "users_profiles_self_insert" ON public.users
  FOR INSERT WITH CHECK ((id)::text = (auth.uid())::text);

DROP POLICY IF EXISTS "users_profiles_self_update" ON public.users;
CREATE POLICY "users_profiles_self_update" ON public.users
  FOR UPDATE USING ((id)::text = (auth.uid())::text)
  WITH CHECK ((id)::text = (auth.uid())::text);

DROP POLICY IF EXISTS "orgs_owner_all" ON public.organizations;
CREATE POLICY "orgs_owner_all" ON public.organizations
  FOR ALL USING ((owner_id)::text = (auth.uid())::text)
  WITH CHECK ((owner_id)::text = (auth.uid())::text);

-- events ---------------------------------------------------------------------
DROP POLICY IF EXISTS "events_public_read" ON public.events;
CREATE POLICY "events_public_read" ON public.events
  FOR SELECT USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "events_org_insert" ON public.events;
CREATE POLICY "events_org_insert" ON public.events
  FOR INSERT WITH CHECK ((organizer_id)::text = (auth.uid())::text);

DROP POLICY IF EXISTS "events_org_update" ON public.events;
CREATE POLICY "events_org_update" ON public.events
  FOR UPDATE USING ((organizer_id)::text = (auth.uid())::text);

DROP POLICY IF EXISTS "events_org_delete" ON public.events;
CREATE POLICY "events_org_delete" ON public.events
  FOR DELETE USING ((organizer_id)::text = (auth.uid())::text);

-- opportunities ---------------------------------------------------------------
DROP POLICY IF EXISTS "opps_public_read" ON public.opportunities;
CREATE POLICY "opps_public_read" ON public.opportunities
  FOR SELECT USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "opps_org_insert" ON public.opportunities;
CREATE POLICY "opps_org_insert" ON public.opportunities
  FOR INSERT WITH CHECK ((organizer_id)::text = (auth.uid())::text);

DROP POLICY IF EXISTS "opps_org_update" ON public.opportunities;
CREATE POLICY "opps_org_update" ON public.opportunities
  FOR UPDATE USING ((organizer_id)::text = (auth.uid())::text);

DROP POLICY IF EXISTS "opps_org_delete" ON public.opportunities;
CREATE POLICY "opps_org_delete" ON public.opportunities
  FOR DELETE USING ((organizer_id)::text = (auth.uid())::text);

-- dynamic forms + fields (not sensitive once linked to a public opportunity) --
DROP POLICY IF EXISTS "forms_authenticated_read" ON public.dynamic_forms;
CREATE POLICY "forms_authenticated_read" ON public.dynamic_forms
  FOR SELECT USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "forms_authenticated_write" ON public.dynamic_forms;
CREATE POLICY "forms_authenticated_write" ON public.dynamic_forms
  FOR ALL USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "form_fields_authenticated_read" ON public.form_fields;
CREATE POLICY "form_fields_authenticated_read" ON public.form_fields
  FOR SELECT USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "form_fields_authenticated_write" ON public.form_fields;
CREATE POLICY "form_fields_authenticated_write" ON public.form_fields
  FOR ALL USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

-- application submissions -----------------------------------------------------
DROP POLICY IF EXISTS "apps_student_insert" ON public.application_submissions;
CREATE POLICY "apps_student_insert" ON public.application_submissions
  FOR INSERT WITH CHECK ((student_id)::text = (auth.uid())::text);

-- organizers only see submissions to their own openings;
-- students only see their own.
DROP POLICY IF EXISTS "apps_owner_or_student_read" ON public.application_submissions;
CREATE POLICY "apps_owner_or_student_read" ON public.application_submissions
  FOR SELECT USING (
    (student_id)::text = (auth.uid())::text
    OR (organizer_id)::text = (auth.uid())::text
  );

DROP POLICY IF EXISTS "apps_owner_or_student_update" ON public.application_submissions;
CREATE POLICY "apps_owner_or_student_update" ON public.application_submissions
  FOR UPDATE USING (
    (student_id)::text = (auth.uid())::text
    OR (organizer_id)::text = (auth.uid())::text
  )
  WITH CHECK (
    (student_id)::text = (auth.uid())::text
    OR (organizer_id)::text = (auth.uid())::text
  );

-- submission answers: readable by the owning student + the opportunity's organizer
DROP POLICY IF EXISTS "answers_participants_read" ON public.submission_answers;
CREATE POLICY "answers_participants_read" ON public.submission_answers
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.application_submissions s
      WHERE s.id::text = submission_answers.submission_id::text
        AND (
          (s.student_id)::text = (auth.uid())::text
          OR (s.organizer_id)::text = (auth.uid())::text
        )
    )
  );

DROP POLICY IF EXISTS "answers_student_insert" ON public.submission_answers;
CREATE POLICY "answers_student_insert" ON public.submission_answers
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.application_submissions s
      WHERE s.id::text = submission_answers.submission_id::text
        AND (s.student_id)::text = (auth.uid())::text
    )
  );
