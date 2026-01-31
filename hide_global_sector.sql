-- ================================================================
-- HIDE GLOBAL SECTOR FROM PUBLIC VIEW
-- ================================================================
-- The Global sector exists only to hold global quests.
-- Users should not see or access it directly.

BEGIN;

-- Option 1: Use is_active = false to hide it
UPDATE public.sectors 
SET is_active = false,
    display_order = -999  -- Ensure it's always at the bottom if somehow shown
WHERE id = '00000000-0000-0000-0000-000000000000';

-- Option 2 (Better): Add a is_hidden column if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'sectors' AND column_name = 'is_hidden') THEN
        ALTER TABLE public.sectors ADD COLUMN is_hidden BOOLEAN DEFAULT FALSE;
    END IF;
END $$;

-- Mark Global sector as hidden
UPDATE public.sectors 
SET is_hidden = true
WHERE id = '00000000-0000-0000-0000-000000000000';

-- Also hide the Global community
UPDATE public.community 
SET is_public = false
WHERE id = '00000000-0000-0000-0000-000000000000';

COMMIT;
