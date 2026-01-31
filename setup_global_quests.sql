-- ================================================================
-- SETUP GLOBAL SECTOR AND COMMUNITY
-- ================================================================

BEGIN;

-- 1. Ensure SECTORS table exists (Migrate from ENUM if needed)
CREATE TABLE IF NOT EXISTS public.sectors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon_name TEXT, -- Material icon name
    color_hex TEXT, -- e.g. #FF5733
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Add sector_id to community if not exists
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'community' AND column_name = 'sector_id') THEN
        ALTER TABLE public.community ADD COLUMN sector_id UUID REFERENCES public.sectors(id);
    END IF;
END $$;

-- 3. Insert the GLOBAL SECTOR
-- Using the fixed UUID as requested
INSERT INTO public.sectors (id, name, description, icon_name, color_hex, display_order)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Global',
  'The universal sector for all Monocle users.',
  'public',
  '#6200EA', -- Deep Purple
  -1 -- Ensure it appears first/special
)
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name, description = EXCLUDED.description;

-- 4. Insert the GLOBAL COMMUNITY linked to the Global Sector
INSERT INTO public.community (id, name, description, is_public, is_verified, owner_id, sector_id)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Global Community',
  'The official global community for all Monocle users.',
  true,
  true,
  '00000000-0000-0000-0000-000000000000', -- Using Global System User as owner
  '00000000-0000-0000-0000-000000000000' -- Link to Global Sector
)
ON CONFLICT (id) DO UPDATE 
SET sector_id = EXCLUDED.sector_id;

-- 5. Update existing 'global' quests to be linked to this community
UPDATE public.quests
SET community_id = '00000000-0000-0000-0000-000000000000'
WHERE type = 'global';

COMMIT;
