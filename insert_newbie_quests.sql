-- ================================================================
-- NEWBIE-FRIENDLY GLOBAL QUESTS (Updated Orb Rewards)
-- ================================================================
-- Orb Reward Logic:
-- - Common/Uncommon quests: 0 Orbs (Shards only)
-- - Rare quests: 5 Orbs (difficult or achievement type)
-- - Epic quests: 15 Orbs
-- - Legendary quests: 50 Orbs

BEGIN;

-- Quest 1: Welcome Quest - Complete Your Profile (Common - No Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Welcome to Monocle!',
    'Complete your profile to introduce yourself to the community.',
    'global',
    'common',
    50,  -- Shards
    0,   -- Orbs (Common = no orbs)
    100, -- XP
    '[{"id": "1", "description": "Set your display name", "type": "complete_profile", "target_count": 1, "current_count": 0},
      {"id": "2", "description": "Add a profile picture", "type": "complete_profile", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 2: First Steps - Join a Community (Common - No Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'First Steps',
    'Join your first community and start connecting with others.',
    'global',
    'common',
    75,  -- Shards
    0,   -- Orbs (Common = no orbs)
    150, -- XP
    '[{"id": "1", "description": "Join a community", "type": "join_community", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 3: Social Butterfly - Chat with users (Common - No Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Social Butterfly',
    'Start conversations and make new friends in the community.',
    'global',
    'common',
    100, -- Shards
    0,   -- Orbs (Common = no orbs)
    200, -- XP
    '[{"id": "1", "description": "Send 5 messages in any community", "type": "send_message", "target_count": 5, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 4: Explorer - Visit Multiple Sectors (Uncommon - No Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Sector Explorer',
    'Discover different sectors and find communities that interest you.',
    'global',
    'uncommon',
    150, -- Shards
    0,   -- Orbs (Uncommon = no orbs)
    250, -- XP
    '[{"id": "1", "description": "Visit 3 different sectors", "type": "custom", "target_count": 3, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 5: Generous Spirit - Make Your First Transfer (Uncommon - No Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Generous Spirit',
    'Share some Shards with another user to spread the love.',
    'global',
    'uncommon',
    200, -- Shards
    0,   -- Orbs (Uncommon = no orbs)
    300, -- XP
    '[{"id": "1", "description": "Transfer Shards to another user", "type": "make_transfer", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 6: Daily Devotion - Login Streak (Common - No Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, is_repeatable, created_at
) VALUES (
    uuid_generate_v4(),
    'Daily Devotion',
    'Show your commitment by logging in for 3 consecutive days.',
    'global',
    'common',
    100, -- Shards
    0,   -- Orbs (Common = no orbs)
    200, -- XP
    '[{"id": "1", "description": "Login for 3 consecutive days", "type": "login_streak", "target_count": 3, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    true,
    NOW()
);

-- Quest 7: Community Builder - Invite a Friend (RARE - 5 Orbs!)
-- This is an achievement-type quest (difficult)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Community Builder',
    'Invite a friend to join Monocle and grow our community together.',
    'global',
    'rare',
    500, -- Shards
    5,   -- Orbs (Rare = 5 orbs for achievement)
    500, -- XP
    '[{"id": "1", "description": "Invite a new user who signs up", "type": "invite_user", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 8: Shard Collector - Earn Your First 500 Shards (Uncommon - No Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Shard Collector',
    'Accumulate 500 Shards from completing activities.',
    'global',
    'uncommon',
    100, -- Bonus Shards
    0,   -- Orbs (Uncommon = no orbs)
    350, -- XP
    '[{"id": "1", "description": "Earn 500 total Shards", "type": "earn_shards", "target_count": 500, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- ================================================================
-- ADVANCED QUESTS (Rare, Epic, Legendary - WITH Orbs)
-- ================================================================

-- Quest 9: Super Connector (RARE - 5 Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Super Connector',
    'Join 5 different communities and become a networking pro.',
    'global',
    'rare',
    750, -- Shards
    5,   -- Orbs (Rare = 5 orbs)
    600, -- XP
    '[{"id": "1", "description": "Join 5 communities", "type": "join_community", "target_count": 5, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 10: Week Warrior (EPIC - 15 Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Week Warrior',
    'Maintain a 7-day login streak. Dedication pays off!',
    'global',
    'epic',
    1000, -- Shards
    15,   -- Orbs (Epic = 15 orbs)
    1000, -- XP
    '[{"id": "1", "description": "Login for 7 consecutive days", "type": "login_streak", "target_count": 7, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 11: Legendary Recruiter (LEGENDARY - 50 Orbs)
INSERT INTO public.quests (
    id, title, description, type, rarity,
    reward_sparks, reward_orbs, xp_reward,
    objectives, community_id, is_active, created_at
) VALUES (
    uuid_generate_v4(),
    'Legendary Recruiter',
    'Invite 10 friends to Monocle. You are a true ambassador!',
    'global',
    'legendary',
    5000, -- Shards
    50,   -- Orbs (Legendary = 50 orbs)
    2500, -- XP
    '[{"id": "1", "description": "Invite 10 users who sign up", "type": "invite_user", "target_count": 10, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

COMMIT;
