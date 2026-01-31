-- ================================================================
-- COMPREHENSIVE FIX FOR NULL VALUES IN QUESTS TABLE
-- ================================================================
-- This script fixes ALL potential null issues that could cause
-- "Null is not a subtype of type 'num'" errors

BEGIN;

-- 1. Fix NULL values in numeric columns
UPDATE public.quests SET reward_sparks = 0 WHERE reward_sparks IS NULL;
UPDATE public.quests SET reward_orbs = 0 WHERE reward_orbs IS NULL;
UPDATE public.quests SET xp_reward = 0 WHERE xp_reward IS NULL;
UPDATE public.quests SET current_completions = 0 WHERE current_completions IS NULL;

-- 2. Fix NULL objectives - set to empty array if null
UPDATE public.quests SET objectives = '[]'::jsonb WHERE objectives IS NULL;

-- 3. Fix objectives with null target_count or current_count inside the JSONB
-- This updates each objective element to have proper default values
UPDATE public.quests
SET objectives = (
    SELECT jsonb_agg(
        obj || 
        jsonb_build_object(
            'target_count', COALESCE((obj->>'target_count')::int, 1),
            'current_count', COALESCE((obj->>'current_count')::int, 0)
        )
    )
    FROM jsonb_array_elements(objectives) AS obj
)
WHERE objectives IS NOT NULL 
  AND objectives != '[]'::jsonb
  AND jsonb_typeof(objectives) = 'array';

-- 4. Ensure created_at is not null (required field)
UPDATE public.quests SET created_at = NOW() WHERE created_at IS NULL;

-- 5. Set default rarity if null
UPDATE public.quests SET rarity = 'common' WHERE rarity IS NULL;

-- 6. Ensure is_repeatable has a value
UPDATE public.quests SET is_repeatable = false WHERE is_repeatable IS NULL;

-- 7. Set default column constraints to prevent future nulls
ALTER TABLE public.quests 
    ALTER COLUMN reward_sparks SET DEFAULT 0,
    ALTER COLUMN reward_orbs SET DEFAULT 0,
    ALTER COLUMN xp_reward SET DEFAULT 0,
    ALTER COLUMN current_completions SET DEFAULT 0,
    ALTER COLUMN objectives SET DEFAULT '[]'::jsonb,
    ALTER COLUMN rarity SET DEFAULT 'common',
    ALTER COLUMN is_repeatable SET DEFAULT false,
    ALTER COLUMN created_at SET DEFAULT NOW();

COMMIT;
