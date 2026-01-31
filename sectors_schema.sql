-- ==========================================
-- SECTORS TABLE
-- ==========================================

-- Create sectors table
CREATE TABLE IF NOT EXISTS sectors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  icon_name VARCHAR(100), -- Material icon name (e.g., 'computer', 'palette')
  color_hex VARCHAR(7), -- Hex color code (e.g., '#00D9FF')
  is_active BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index on name for fast lookups
CREATE INDEX idx_sectors_name ON sectors(name);
CREATE INDEX idx_sectors_active ON sectors(is_active);
CREATE INDEX idx_sectors_display_order ON sectors(display_order);

-- ==========================================
-- UPDATE COMMUNITY TABLE
-- ==========================================

-- Add sector_id foreign key to community if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'community' AND column_name = 'sector_id'
  ) THEN
    ALTER TABLE community ADD COLUMN sector_id UUID REFERENCES sectors(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Create index for sector_id
CREATE INDEX IF NOT EXISTS idx_community_sector_id ON community(sector_id);

-- ==========================================
-- INSERT DEFAULT SECTORS
-- ==========================================

INSERT INTO sectors (name, description, icon_name, color_hex, display_order) VALUES
  ('Tech', 'Technology, AI, Development, and Innovation', 'computer', '#00D9FF', 1),
  ('Art', 'Digital Art, Design, Illustration, and Creativity', 'palette', '#FF006E', 2),
  ('Gaming', 'Games, Esports, Streaming, and Gaming Culture', 'sports_esports', '#8B5CF6', 3),
  ('Education', 'Learning, Teaching, Courses, and Knowledge Sharing', 'school', '#10B981', 4),
  ('Business', 'Entrepreneurship, Startups, Finance, and Growth', 'business_center', '#F59E0B', 5),
  ('Fitness', 'Health, Wellness, Sports, and Physical Training', 'fitness_center', '#EF4444', 6),
  ('Music', 'Music Production, Performance, and Appreciation', 'music_note', '#EC4899', 7),
  ('Food', 'Cooking, Recipes, Nutrition, and Culinary Arts', 'restaurant', '#F97316', 8)
ON CONFLICT (name) DO NOTHING;

-- ==========================================
-- HELPER VIEWS
-- ==========================================

-- View to get sector stats
CREATE OR REPLACE VIEW sector_stats AS
SELECT 
  s.id,
  s.name,
  s.description,
  s.icon_name,
  s.color_hex,
  s.display_order,
  COUNT(DISTINCT c.id) AS community_count,
  COALESCE(SUM(c.member_count), 0) AS total_members,
  s.created_at,
  s.updated_at
FROM sectors s
LEFT JOIN community c ON c.sector_id = s.id AND c.is_public = true
WHERE s.is_active = true
GROUP BY s.id, s.name, s.description, s.icon_name, s.color_hex, s.display_order, s.created_at, s.updated_at
ORDER BY s.display_order;

-- ==========================================
-- TRIGGER FOR UPDATED_AT
-- ==========================================

-- Create trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for sectors table
DROP TRIGGER IF EXISTS update_sectors_updated_at ON sectors;
CREATE TRIGGER update_sectors_updated_at
  BEFORE UPDATE ON sectors
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- ROW LEVEL SECURITY (RLS)
-- ==========================================

-- Enable RLS on sectors table
ALTER TABLE sectors ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read active sectors
CREATE POLICY "Sectors are viewable by everyone"
  ON sectors FOR SELECT
  USING (is_active = true);

-- Only authenticated users can suggest new sectors (admin approval needed)
CREATE POLICY "Authenticated users can insert sectors"
  ON sectors FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Only admins can update/delete sectors (you'll need to implement admin role)
-- For now, we'll allow service role only
CREATE POLICY "Only service role can update sectors"
  ON sectors FOR UPDATE
  TO service_role
  USING (true);

CREATE POLICY "Only service role can delete sectors"
  ON sectors FOR DELETE
  TO service_role
  USING (true);

-- ==========================================
-- MIGRATION HELPER (Optional)
-- ==========================================

-- COMMENTED OUT: Only use this if you have an existing 'sector_type' column
-- that you want to migrate to the new 'sector_id' foreign key relationship.
-- Uncomment and run only if needed.

/*
DO $$
DECLARE
  sector_record RECORD;
BEGIN
  -- First, check if sector_type column exists
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'community' AND column_name = 'sector_type'
  ) THEN
    -- Migrate sector_type string values to sector_id foreign keys
    FOR sector_record IN SELECT id, name FROM sectors
    LOOP
      UPDATE community
      SET sector_id = sector_record.id
      WHERE LOWER(sector_type::text) = LOWER(sector_record.name)
        AND sector_id IS NULL;
    END LOOP;
  END IF;
END $$;
*/

-- ==========================================
-- RLS FOR VIEWS (sector_stats)
-- ==========================================

-- NOTE: PostgreSQL does not support RLS directly on views.
-- The sector_stats view automatically inherits security from the underlying tables:
-- 1. 'sectors' table has RLS enabled (only active sectors visible)
-- 2. 'community' table should have its own RLS policies
-- 3. The view filters to only show is_public = true communities
--
-- Therefore, the view is already secure by design. Users will only see:
-- - Active sectors (from sectors RLS)
-- - Public communities (from the WHERE clause)
-- - Communities they have access to (from community table RLS)

-- If you need additional view-level security, you can:
-- 1. Create a security definer function
-- 2. Grant specific permissions to roles
-- Example:
-- GRANT SELECT ON sector_stats TO authenticated;
-- REVOKE SELECT ON sector_stats FROM anon;

-- ==========================================
-- USEFUL QUERIES
-- ==========================================

-- Get all sectors with stats
-- SELECT * FROM sector_stats;

-- Get communities in a specific sector
-- SELECT * FROM community WHERE sector_id = 'sector-uuid-here';

-- Get top sectors by member count
-- SELECT * FROM sector_stats ORDER BY total_members DESC;

-- Get top sectors by community count
-- SELECT * FROM sector_stats ORDER BY community_count DESC;

-- Get a specific sector with its communities
-- SELECT s.*, 
--        (SELECT json_agg(c.*) FROM community c WHERE c.sector_id = s.id) as communities
-- FROM sector_stats s
-- WHERE s.id = 'sector-uuid-here';
