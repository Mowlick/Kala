-- ============================================================================
-- KALĀ — Organizer ↔ Event ↔ Student ↔ Application workflow fixes
-- Idempotent. Safe to re-run. Run in Supabase → SQL Editor.
-- ============================================================================

-- 1. users: columns the app writes during onboarding
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS city TEXT,
  ADD COLUMN IF NOT EXISTS bio TEXT;

-- 2. events: denormalized org display + real organizer ownership
ALTER TABLE public.events
  ADD COLUMN IF NOT EXISTS organization_name TEXT,
  ADD COLUMN IF NOT EXISTS organization_logo TEXT,
  ADD COLUMN IF NOT EXISTS is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS organizer_id UUID REFERENCES public.users(id) ON DELETE SET NULL;

-- 3. opportunities: organizer ownership + category (app writes 'category')
ALTER TABLE public.opportunities
  ADD COLUMN IF NOT EXISTS organizer_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS category TEXT,
  ALTER COLUMN type DROP NOT NULL;

-- 4. application_submissions: organizer link + student email
ALTER TABLE public.application_submissions
  ADD COLUMN IF NOT EXISTS organizer_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS student_email TEXT;

-- 5. dynamic_forms: form ↔ opportunity link
ALTER TABLE public.dynamic_forms
  ADD COLUMN IF NOT EXISTS opportunity_id UUID REFERENCES public.opportunities(id) ON DELETE SET NULL;

-- 6. organizations: one profile row per organizer (for 1:1 auth→org)
CREATE UNIQUE INDEX IF NOT EXISTS organizations_owner_id_key ON public.organizations (owner_id);

-- 7. performance indexes for the workflow queries
CREATE INDEX IF NOT EXISTS idx_events_organizer_id ON public.events (organizer_id);
CREATE INDEX IF NOT EXISTS idx_opportunities_organizer_id ON public.opportunities (organizer_id);
CREATE INDEX IF NOT EXISTS idx_opportunities_event_id ON public.opportunities (event_id);
CREATE INDEX IF NOT EXISTS idx_submissions_opportunity_id ON public.application_submissions (opportunity_id);
CREATE INDEX IF NOT EXISTS idx_submissions_student_id ON public.application_submissions (student_id);
CREATE INDEX IF NOT EXISTS idx_submissions_organizer_id ON public.application_submissions (organizer_id);

-- 8. realtime sync for the workflow tables (publish → appear instantly).
--    Idempotent: skips tables already in the publication.
DO $$
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['events', 'opportunities', 'dynamic_forms', 'application_submissions']
  LOOP
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
-- Row Level Security (RECOMMENDED for production). DO NOT enable until the
-- app has been confirmed working end-to-end — RLS changes query behaviour.
--
-- Enable with:
--   ALTER TABLE ... ENABLE ROW LEVEL SECURITY;
--   (then run the policies below)
--
-- These policies use auth.uid() from the signed-in user's JWT. The app never
-- trusts client-supplied ids for ownership: every owner relationship is
-- written from the authenticated user id at submit-time.
-- ============================================================================

-- ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.opportunities ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.application_submissions ENABLE ROW LEVEL SECURITY;

-- CREATE POLICY "users_profiles_read" ON public.users
--   FOR SELECT USING (auth.uid() IS NOT NULL);
-- CREATE POLICY "users_profiles_self_update" ON public.users
--   FOR UPDATE USING ((id)::text = (auth.uid())::text)
--   WITH CHECK ((id)::text = (auth.uid())::text);

-- CREATE POLICY "orgs_owner_all" ON public.organizations
--   FOR ALL USING ((owner_id)::text = (auth.uid())::text);

-- CREATE POLICY "events_org_insert" ON public.events
--   FOR INSERT WITH CHECK ((organizer_id)::text = (auth.uid())::text);
-- CREATE POLICY "events_public_read" ON public.events
--   FOR SELECT USING (auth.uid() IS NOT NULL);
-- CREATE POLICY "events_org_update" ON public.events
--   FOR UPDATE USING ((organizer_id)::text = (auth.uid())::text);
-- CREATE POLICY "events_org_delete" ON public.events
--   FOR DELETE USING ((organizer_id)::text = (auth.uid())::text);

-- CREATE POLICY "opps_org_insert" ON public.opportunities
--   FOR INSERT WITH CHECK ((organizer_id)::text = (auth.uid())::text);
-- CREATE POLICY "opps_public_read" ON public.opportunities
--   FOR SELECT USING (auth.uid() IS NOT NULL);
-- CREATE POLICY "opps_org_update" ON public.opportunities
--   FOR UPDATE USING ((organizer_id)::text = (auth.uid())::text);
-- CREATE POLICY "opps_org_delete" ON public.opportunities
--   FOR DELETE USING ((organizer_id)::text = (auth.uid())::text);

-- CREATE POLICY "apps_student_insert" ON public.application_submissions
--   FOR INSERT WITH CHECK ((student_id)::text = (auth.uid())::text);
-- CREATE POLICY "apps_self_read" ON public.application_submissions
--   FOR SELECT USING (
--     (student_id)::text = (auth.uid())::text OR (organizer_id)::text = (auth.uid())::text
--   );
-- CREATE POLICY "apps_owner_update" ON public.application_submissions
--   FOR UPDATE USING (
--     (student_id)::text = (auth.uid())::text OR (organizer_id)::text = (auth.uid())::text
--   );