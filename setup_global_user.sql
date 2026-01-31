-- ================================================================
-- SETUP GLOBAL SYSTEM USER (Ghosty Lab Inc)
-- ================================================================

BEGIN;

-- 1. Insert into auth.users (System Account)
-- We need this to satisfy Foreign Key constraints
INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, is_super_admin)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  '00000000-0000-0000-0000-000000000000',
  'ghostylabinc@gmail.com',
  '$2a$10$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMN0123456789', -- Dummy hash, login not intended via password
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"name":"Ghosty Lab Inc"}',
  NOW(),
  NOW(),
  'authenticated', -- or 'service_role'
  false
)
ON CONFLICT (id) DO NOTHING;

-- 2. Insert/Update Profile for Global User
INSERT INTO public.profiles (id, username, display_name, email, avatar_url, level, xp, reputation, bio)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'MonocleGlobal',
  'Ghosty Lab Inc',
  'ghostylabinc@gmail.com',
  'https://ui-avatars.com/api/?name=Ghosty+Lab&background=6200EA&color=fff', -- Default avatar
  1000, -- Highest Level
  999999999, -- Max XP
  100000, -- Max Reputation
  'Official System Account for Global Quests and Events.'
)
ON CONFLICT (id) DO UPDATE
SET 
    level = EXCLUDED.level,
    xp = EXCLUDED.xp,
    reputation = EXCLUDED.reputation;

-- 3. Update Global Community Owner
UPDATE public.community
SET owner_id = '00000000-0000-0000-0000-000000000000'
WHERE id = '00000000-0000-0000-0000-000000000000';

COMMIT;
