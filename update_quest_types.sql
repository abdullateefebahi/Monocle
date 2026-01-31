-- ================================================================
-- UPDATE QUEST_TYPE ENUM TO INCLUDE NEW TYPES
-- ================================================================
-- This adds 'global', 'sector', and 'mission' to the quest_type enum

BEGIN;

-- PostgreSQL doesn't support easy enum modification, so we need to:
-- 1. Add new values to the existing enum

-- Add 'global' if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'global' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'quest_type')) THEN
        ALTER TYPE quest_type ADD VALUE 'global';
    END IF;
END $$;

-- Add 'sector' if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'sector' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'quest_type')) THEN
        ALTER TYPE quest_type ADD VALUE 'sector';
    END IF;
END $$;

-- Add 'mission' if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'mission' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'quest_type')) THEN
        ALTER TYPE quest_type ADD VALUE 'mission';
    END IF;
END $$;

COMMIT;
