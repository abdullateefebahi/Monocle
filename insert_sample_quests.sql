
-- Insert Sample Global Quests
INSERT INTO public.quests (title, description, type, rarity, difficulty, reward_sparks, xp_reward, objectives, is_active)
VALUES 
    ('Weekly Global: Explorer', 'Complete 3 sector visits this week', 'global', 'common', 'easy', 100, 200, 
     '[{"id": "1", "description": "Visit 3 different sectors", "type": "custom", "target_count": 3, "current_count": 0}]', true),
    
    ('Weekly Global: Socializer', 'Chat in global hub for 3 days', 'global', 'uncommon', 'medium', 150, 300, 
     '[{"id": "1", "description": "Chat streaks", "type": "login_streak", "target_count": 3, "current_count": 0}]', true);

-- Insert Sample Mission (requires community)
-- Note: Assuming you have a community. If not, this might fail or we can insert without community_id if allowed (schema says nullable but missions usually have one).
-- For now, let's insert a "Public Mission" (without community_id for demo purposes or create a dummy community ID if needed)

-- Update existing quests to be 'story' or 'daily' if needed, but the defaults were fine.
