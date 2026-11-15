-- ============================================================================
-- KALĀ — Fix events.status CHECK constraint mismatch (publish → live sync)
-- Idempotent. Safe to re-run. Run in Supabase → SQL Editor AFTER 002.
--
-- The app persists EventStatus enum names ('draft', 'registrationOpen',
-- 'live', …) but the legacy MVP schema shipped a check constraint that only
-- accepted ('Draft','Ongoing','Completed'). Every event publish therefore
-- failed and never reached the student "Live From Organizers" section.
-- ============================================================================

-- 1. Drop the stale constraint if present.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.events'::regclass
      AND conname = 'events_status_check'
  ) THEN
    ALTER TABLE public.events DROP CONSTRAINT events_status_check;
  END IF;
END $$;

-- 2. Migrate any legacy rows to the app's enum vocabulary.
UPDATE public.events SET status = 'draft'     WHERE status = 'Draft';
UPDATE public.events SET status = 'live'      WHERE status = 'Ongoing';
UPDATE public.events SET status = 'completed' WHERE status = 'Completed';

-- Safety net: anything still invalid becomes a draft so the constraint applies.
UPDATE public.events SET status = 'draft'
  WHERE status NOT IN (
    'draft','upcoming','registrationOpen','applicationsClosed',
    'screening','interviews','live','completed','archived'
  );

-- 3. Re-add the constraint matching the app's EventStatus enum names.
ALTER TABLE public.events
  ADD CONSTRAINT events_status_check CHECK (status IN (
    'draft','upcoming','registrationOpen','applicationsClosed',
    'screening','interviews','live','completed','archived'
  ));
