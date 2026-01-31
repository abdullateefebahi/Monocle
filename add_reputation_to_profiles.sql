-- ================================================================
-- ADD REPUTATION COLUMN TO PROFILES TABLE
-- ================================================================

BEGIN;

-- Add reputation column if it doesn't exist
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS reputation INTEGER DEFAULT 0;

-- Optional: Add an index on reputation if you plan to query/sort by it frequently
CREATE INDEX IF NOT EXISTS idx_profiles_reputation ON public.profiles(reputation DESC);

COMMIT;
