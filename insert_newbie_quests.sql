-- ================================================================
-- NEWBIE-FRIENDLY GLOBAL QUESTS
-- ================================================================
-- Easy quests for new users to get started with Monocle

BEGIN;

-- Quest 1: Welcome Quest - Complete Your Profile
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
    50, -- Shards
    5,  -- Orbs
    100, -- XP
    '[{"id": "1", "description": "Set your display name", "type": "complete_profile", "target_count": 1, "current_count": 0},
      {"id": "2", "description": "Add a profile picture", "type": "complete_profile", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000', -- Global Community ID
    true,
    NOW()
);

-- Quest 2: First Steps - Join a Community
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
    75, -- Shards
    10, -- Orbs
    150, -- XP
    '[{"id": "1", "description": "Join a community", "type": "join_community", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 3: Social Butterfly - Chat with users
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
    10, -- Orbs
    200, -- XP
    '[{"id": "1", "description": "Send 5 messages in any community", "type": "send_message", "target_count": 5, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 4: Explorer - Visit Multiple Sectors
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
    15, -- Orbs
    250, -- XP
    '[{"id": "1", "description": "Visit 3 different sectors", "type": "custom", "target_count": 3, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 5: Generous Spirit - Make Your First Transfer
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
    200, -- Shards (more than given to encourage)
    20, -- Orbs
    300, -- XP
    '[{"id": "1", "description": "Transfer Shards to another user", "type": "make_transfer", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 6: Daily Devotion - Login Streak
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
    15, -- Orbs
    200, -- XP
    '[{"id": "1", "description": "Login for 3 consecutive days", "type": "login_streak", "target_count": 3, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    true, -- Repeatable weekly
    NOW()
);

-- Quest 7: Community Builder - Invite a Friend
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
    50, -- Orbs
    500, -- XP
    '[{"id": "1", "description": "Invite a new user who signs up", "type": "invite_user", "target_count": 1, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

-- Quest 8: Shard Collector - Earn Your First 500 Shards
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
    25, -- Orbs
    350, -- XP
    '[{"id": "1", "description": "Earn 500 total Shards", "type": "earn_shards", "target_count": 500, "current_count": 0}]'::jsonb,
    '00000000-0000-0000-0000-000000000000',
    true,
    NOW()
);

COMMIT;
