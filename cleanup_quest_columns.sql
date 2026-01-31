-- ================================================================
-- CLEANUP AND SIMPLIFY QUESTS TABLE
-- ================================================================
-- This script aligns the Quests table with the simplified QuestModel,
-- removing no longer used columns to avoid confusion.

BEGIN;

-- 1. Remove columns that are no longer in the QuestModel
ALTER TABLE public.quests 
DROP COLUMN IF EXISTS icon_url,
DROP COLUMN IF EXISTS rarity,
DROP COLUMN IF EXISTS xp_reward,
DROP COLUMN IF EXISTS max_completions,
DROP COLUMN IF EXISTS is_repeatable,
DROP COLUMN IF EXISTS difficulty; -- Was present in SQL but never in Model

-- 2. Ensure remaining numeric columns have default 0
ALTER TABLE public.quests 
ALTER COLUMN reward_sparks SET DEFAULT 0,
ALTER COLUMN reward_orbs SET DEFAULT 0,
ALTER COLUMN current_completions SET DEFAULT 0;

-- 3. Update existing NULLs to 0 just in case
UPDATE public.quests SET reward_sparks = 0 WHERE reward_sparks IS NULL;
UPDATE public.quests SET reward_orbs = 0 WHERE reward_orbs IS NULL;
UPDATE public.quests SET current_completions = 0 WHERE current_completions IS NULL;

COMMIT;
