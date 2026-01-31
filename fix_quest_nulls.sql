-- ================================================================
-- FIX FOR NULL VALUES IN QUESTS TABLE
-- ================================================================
-- This script updates any existing NULL values in numeric columns to 0
-- to prevent "Null is not a subtype of num" errors in the app.

BEGIN;

-- 1. Update reward_sparks
UPDATE public.quests 
SET reward_sparks = 0 
WHERE reward_sparks IS NULL;

-- 2. Update reward_orbs
UPDATE public.quests 
SET reward_orbs = 0 
WHERE reward_orbs IS NULL;

-- 3. Update xp_reward
UPDATE public.quests 
SET xp_reward = 0 
WHERE xp_reward IS NULL;

-- 4. Update current_completions
UPDATE public.quests 
SET current_completions = 0 
WHERE current_completions IS NULL;

-- 5. Optional: Enforce NOT NULL constraints to prevent future issues
-- Uncomment these lines if you want to strictly enforce non-null values
-- ALTER TABLE public.quests ALTER COLUMN reward_sparks SET NOT NULL;
-- ALTER TABLE public.quests ALTER COLUMN reward_orbs SET NOT NULL;
-- ALTER TABLE public.quests ALTER COLUMN xp_reward SET NOT NULL;
-- ALTER TABLE public.quests ALTER COLUMN current_completions SET NOT NULL;

COMMIT;
