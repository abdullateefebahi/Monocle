-- ============================================
-- Project Monocle - Supabase Database Schema
-- ============================================
-- Run this in your Supabase SQL Editor
-- ============================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- 1. PROFILES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    username TEXT UNIQUE,
    display_name TEXT,
    avatar_url TEXT,
    bio TEXT CHECK (char_length(bio) <= 500),
    profession_tag TEXT,
    phone_number TEXT,
    matriculation_number TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    is_onboarding_complete BOOLEAN DEFAULT FALSE,
    level INTEGER DEFAULT 1,
    total_xp INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for profiles
CREATE INDEX idx_profiles_username ON public.profiles(username);
CREATE INDEX idx_profiles_level ON public.profiles(level DESC);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Public profiles are viewable by everyone"
    ON public.profiles FOR SELECT
    USING (true);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- ============================================
-- 2. USER_WALLETS TABLE (Currency Ledger)
-- ============================================
CREATE TABLE IF NOT EXISTS public.user_wallets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    spark_balance INTEGER DEFAULT 0 CHECK (spark_balance >= 0), -- Soft currency
    orb_balance INTEGER DEFAULT 0 CHECK (orb_balance >= 0),     -- Hard currency
    lifetime_sparks_earned INTEGER DEFAULT 0,
    lifetime_orbs_earned INTEGER DEFAULT 0,
    last_daily_bonus_at TIMESTAMPTZ,
    last_updated TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for wallets
CREATE INDEX idx_user_wallets_user_id ON public.user_wallets(user_id);

-- Enable RLS
ALTER TABLE public.user_wallets ENABLE ROW LEVEL SECURITY;

-- Policies for wallets
CREATE POLICY "Users can view own wallet"
    ON public.user_wallets FOR SELECT
    USING (auth.uid() = user_id);

-- Only backend can modify wallets (via service role)
CREATE POLICY "Service role can modify wallets"
    ON public.user_wallets FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================
-- 3. TRANSACTIONS TABLE (Immutable Ledger)
-- ============================================
CREATE TYPE transaction_type AS ENUM ('credit', 'debit', 'transfer', 'reward', 'purchase', 'refund');
CREATE TYPE currency_type AS ENUM ('spark', 'orb');

CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type transaction_type NOT NULL,
    currency currency_type NOT NULL,
    amount INTEGER NOT NULL CHECK (amount > 0),
    balance_after INTEGER NOT NULL CHECK (balance_after >= 0),
    description TEXT,
    reference_id UUID,
    reference_type TEXT, -- 'quest', 'mission', 'event', 'transfer', 'purchase'
    from_user_id UUID REFERENCES auth.users(id),
    to_user_id UUID REFERENCES auth.users(id),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for faster queries
CREATE INDEX idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX idx_transactions_type ON public.transactions(type);
CREATE INDEX idx_transactions_created_at ON public.transactions(created_at DESC);
CREATE INDEX idx_transactions_reference ON public.transactions(reference_id, reference_type);

-- Enable RLS
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Policies for transactions
CREATE POLICY "Users can view own transactions"
    ON public.transactions FOR SELECT
    USING (auth.uid() = user_id OR auth.uid() = from_user_id OR auth.uid() = to_user_id);

-- Only backend can insert transactions
CREATE POLICY "Service role can insert transactions"
    ON public.transactions FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

-- ============================================
-- 4. COMMUNITY TABLE
-- ============================================
CREATE TYPE sector_type AS ENUM ('tech', 'art', 'gaming', 'education', 'business', 'general', 'entertainment');

CREATE TABLE IF NOT EXISTS public.community (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL CHECK (char_length(name) >= 3 AND char_length(name) <= 100),
    slug TEXT UNIQUE,
    description TEXT CHECK (char_length(description) <= 1000),
    icon_url TEXT,
    banner_url TEXT,
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    sector_type sector_type NOT NULL DEFAULT 'general',
    is_public BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    is_archived BOOLEAN DEFAULT FALSE,
    member_count INTEGER DEFAULT 0,
    max_members INTEGER DEFAULT 10000,
    settings JSONB DEFAULT '{"allow_invites": true, "require_approval": false, "allow_member_posts": true, "enable_chat": true}',
    tags TEXT[] DEFAULT '{}',
    rules TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for community
CREATE INDEX idx_community_owner ON public.community(owner_id);
CREATE INDEX idx_community_sector ON public.community(sector_type);
CREATE INDEX idx_community_slug ON public.community(slug);
CREATE INDEX idx_community_member_count ON public.community(member_count DESC);

-- Enable RLS
ALTER TABLE public.community ENABLE ROW LEVEL SECURITY;

-- Basic policies for community (member-based policies added later)
CREATE POLICY "Public communities are viewable by everyone"
    ON public.community FOR SELECT
    USING (is_public = true AND is_archived = false);

CREATE POLICY "Owners can update their communities"
    ON public.community FOR UPDATE
    USING (owner_id = auth.uid());

CREATE POLICY "Authenticated users can create communities"
    ON public.community FOR INSERT
    WITH CHECK (auth.uid() = owner_id);

-- ============================================
-- 5. COMMUNITY_MEMBERS TABLE
-- ============================================
CREATE TYPE community_role AS ENUM ('owner', 'admin', 'moderator', 'member');

CREATE TABLE IF NOT EXISTS public.community_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID NOT NULL REFERENCES public.community(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role community_role DEFAULT 'member',
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    is_muted BOOLEAN DEFAULT FALSE,
    is_banned BOOLEAN DEFAULT FALSE,
    custom_nickname TEXT,
    custom_role_data JSONB,
    permissions JSONB DEFAULT '{"can_post": true, "can_comment": true, "can_invite": false}',
    UNIQUE(community_id, user_id)
);

-- Indexes for community_members
CREATE INDEX idx_community_members_community ON public.community_members(community_id);
CREATE INDEX idx_community_members_user ON public.community_members(user_id);
CREATE INDEX idx_community_members_role ON public.community_members(community_id, role);

-- Enable RLS
ALTER TABLE public.community_members ENABLE ROW LEVEL SECURITY;

-- Policies for community_members
CREATE POLICY "Community members can view memberships"
    ON public.community_members FOR SELECT
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.community c
            WHERE c.id = community_id AND c.is_public = true
        ) OR
        EXISTS (
            SELECT 1 FROM public.community_members cm
            WHERE cm.community_id = community_members.community_id
            AND cm.user_id = auth.uid()
            AND cm.is_active = true
        )
    );

CREATE POLICY "Users can join communities"
    ON public.community_members FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can leave communities"
    ON public.community_members FOR DELETE
    USING (auth.uid() = user_id OR 
           EXISTS (
               SELECT 1 FROM public.community c 
               WHERE c.id = community_id AND c.owner_id = auth.uid()
           ));

CREATE POLICY "Community admins can update members"
    ON public.community_members FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.community_members cm
            WHERE cm.community_id = community_members.community_id
            AND cm.user_id = auth.uid()
            AND cm.role IN ('owner', 'admin')
        )
    );

-- Now add the community policy that depends on community_members
-- Helper function to avoid recursion in policies
CREATE OR REPLACE FUNCTION public.is_community_member(_community_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 
        FROM public.community_members 
        WHERE community_id = _community_id
        AND user_id = auth.uid()
        AND is_active = true
    );
END;
$$;

-- Connect the policy to the helper function
CREATE POLICY "Community members can view their communities"
    ON public.community FOR SELECT
    USING (
        is_community_member(id)
    );

-- ============================================
-- 6. QUESTS TABLE
-- ============================================
CREATE TYPE quest_rarity AS ENUM ('common', 'uncommon', 'rare', 'epic', 'legendary');
CREATE TYPE quest_type AS ENUM ('daily', 'weekly', 'monthly', 'story', 'event', 'community', 'achievement');
CREATE TYPE quest_difficulty AS ENUM ('easy', 'medium', 'hard', 'expert');

CREATE TABLE IF NOT EXISTS public.quests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL CHECK (char_length(title) >= 3),
    description TEXT NOT NULL,
    icon_url TEXT,
    rarity quest_rarity DEFAULT 'common',
    type quest_type NOT NULL,
    difficulty quest_difficulty DEFAULT 'easy',
    reward_sparks INTEGER DEFAULT 0 CHECK (reward_sparks >= 0),
    reward_orbs INTEGER DEFAULT 0 CHECK (reward_orbs >= 0),
    xp_reward INTEGER DEFAULT 0 CHECK (xp_reward >= 0),
    bonus_rewards JSONB DEFAULT '[]', -- Array of bonus items/badges
    objectives JSONB NOT NULL DEFAULT '[]',
    prerequisites JSONB DEFAULT '[]', -- Required quests or level
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    max_completions INTEGER,
    current_completions INTEGER DEFAULT 0,
    is_repeatable BOOLEAN DEFAULT FALSE,
    cooldown_hours INTEGER DEFAULT 24,
    community_id UUID REFERENCES public.community(id) ON DELETE CASCADE,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    created_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for quests
CREATE INDEX idx_quests_type ON public.quests(type);
CREATE INDEX idx_quests_rarity ON public.quests(rarity);
CREATE INDEX idx_quests_active ON public.quests(is_active);
CREATE INDEX idx_quests_community ON public.quests(community_id);
CREATE INDEX idx_quests_dates ON public.quests(start_date, end_date);

-- Enable RLS
ALTER TABLE public.quests ENABLE ROW LEVEL SECURITY;

-- Policies for quests
CREATE POLICY "Active quests are viewable by everyone"
    ON public.quests FOR SELECT
    USING (
        is_active = true AND
        (start_date IS NULL OR start_date <= NOW()) AND
        (end_date IS NULL OR end_date >= NOW())
    );

CREATE POLICY "Community admins can create quests"
    ON public.quests FOR INSERT
    WITH CHECK (
        community_id IS NULL OR
        EXISTS (
            SELECT 1 FROM public.community_members cm
            WHERE cm.community_id = quests.community_id
            AND cm.user_id = auth.uid()
            AND cm.role IN ('owner', 'admin')
        )
    );

-- ============================================
-- 7. USER_QUEST_PROGRESS TABLE
-- ============================================
CREATE TYPE quest_status AS ENUM ('available', 'started', 'in_progress', 'completed', 'claimed', 'expired', 'abandoned');

CREATE TABLE IF NOT EXISTS public.user_quest_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quest_id UUID NOT NULL REFERENCES public.quests(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    status quest_status DEFAULT 'started',
    progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
    objectives JSONB NOT NULL DEFAULT '[]', -- Tracks individual objective progress
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    claimed_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    notes TEXT,
    metadata JSONB DEFAULT '{}',
    UNIQUE(quest_id, user_id, started_at) -- Allow multiple attempts if repeatable
);

-- Indexes for user_quest_progress
CREATE INDEX idx_quest_progress_user ON public.user_quest_progress(user_id);
CREATE INDEX idx_quest_progress_quest ON public.user_quest_progress(quest_id);
CREATE INDEX idx_quest_progress_status ON public.user_quest_progress(status);
CREATE INDEX idx_quest_progress_user_status ON public.user_quest_progress(user_id, status);

-- Enable RLS
ALTER TABLE public.user_quest_progress ENABLE ROW LEVEL SECURITY;

-- Policies for user_quest_progress
CREATE POLICY "Users can view own quest progress"
    ON public.user_quest_progress FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update own quest progress"
    ON public.user_quest_progress FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can start quests"
    ON public.user_quest_progress FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own quest progress"
    ON public.user_quest_progress FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 8. DAILY MISSIONS TABLE (Optional)
-- ============================================
CREATE TABLE IF NOT EXISTS public.daily_missions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    objective_type TEXT NOT NULL,
    target_count INTEGER NOT NULL DEFAULT 1,
    current_count INTEGER DEFAULT 0,
    reward_sparks INTEGER DEFAULT 0,
    reward_orbs INTEGER DEFAULT 0,
    reward_xp INTEGER DEFAULT 0,
    is_complete BOOLEAN DEFAULT FALSE,
    is_claimed BOOLEAN DEFAULT FALSE,
    available_until TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for daily_missions
CREATE INDEX idx_daily_missions_user ON public.daily_missions(user_id);
CREATE INDEX idx_daily_missions_date ON public.daily_missions(available_until);
CREATE INDEX idx_daily_missions_complete ON public.daily_missions(user_id, is_complete);

-- Enable RLS
ALTER TABLE public.daily_missions ENABLE ROW LEVEL SECURITY;

-- Policies for daily_missions
CREATE POLICY "Users can view own missions"
    ON public.daily_missions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update own missions"
    ON public.daily_missions FOR UPDATE
    USING (auth.uid() = user_id);

-- ============================================
-- 9. CHANNELS TABLE (Community Chat)
-- ============================================
CREATE TYPE channel_type AS ENUM ('text', 'announcement', 'voice', 'forum');

CREATE TABLE IF NOT EXISTS public.channels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID NOT NULL REFERENCES public.community(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type channel_type DEFAULT 'text',
    is_default BOOLEAN DEFAULT FALSE,
    is_private BOOLEAN DEFAULT FALSE,
    position INTEGER DEFAULT 0,
    last_message_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for channels
CREATE INDEX idx_channels_community ON public.channels(community_id);
CREATE INDEX idx_channels_position ON public.channels(community_id, position);

-- Enable RLS
ALTER TABLE public.channels ENABLE ROW LEVEL SECURITY;

-- Policies for channels
CREATE POLICY "Channel members can view channels"
    ON public.channels FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.community_members cm
            WHERE cm.community_id = channels.community_id
            AND cm.user_id = auth.uid()
            AND cm.is_active = true
        )
    );

-- ============================================
-- 10. MESSAGES TABLE (Real-time Chat)
-- ============================================
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    channel_id UUID NOT NULL REFERENCES public.channels(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    content TEXT NOT NULL CHECK (char_length(content) <= 2000),
    reply_to UUID REFERENCES public.messages(id),
    attachments JSONB DEFAULT '[]',
    reactions JSONB DEFAULT '{}',
    is_pinned BOOLEAN DEFAULT FALSE,
    is_edited BOOLEAN DEFAULT FALSE,
    is_deleted BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for messages
CREATE INDEX idx_messages_channel ON public.messages(channel_id);
CREATE INDEX idx_messages_user ON public.messages(user_id);
CREATE INDEX idx_messages_created ON public.messages(channel_id, created_at DESC);

-- Enable RLS
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Policies for messages
CREATE POLICY "Channel members can view messages"
    ON public.messages FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.channels c
            JOIN public.community_members cm ON cm.community_id = c.community_id
            WHERE c.id = messages.channel_id
            AND cm.user_id = auth.uid()
            AND cm.is_active = true
        )
    );

CREATE POLICY "Channel members can send messages"
    ON public.messages FOR INSERT
    WITH CHECK (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.channels c
            JOIN public.community_members cm ON cm.community_id = c.community_id
            WHERE c.id = channel_id
            AND cm.user_id = auth.uid()
            AND cm.is_active = true
            AND NOT cm.is_muted
            AND NOT cm.is_banned
        )
    );

CREATE POLICY "Users can update own messages"
    ON public.messages FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own messages"
    ON public.messages FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_community_updated_at
    BEFORE UPDATE ON public.community
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quests_updated_at
    BEFORE UPDATE ON public.quests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update community member count
CREATE OR REPLACE FUNCTION update_community_member_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.is_active = true THEN
        UPDATE public.community
        SET member_count = member_count + 1
        WHERE id = NEW.community_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.community
        SET member_count = member_count - 1
        WHERE id = OLD.community_id;
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' AND OLD.is_active != NEW.is_active THEN
        IF NEW.is_active = true THEN
            UPDATE public.community SET member_count = member_count + 1 WHERE id = NEW.community_id;
        ELSE
            UPDATE public.community SET member_count = member_count - 1 WHERE id = NEW.community_id;
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_community_member_change
    AFTER INSERT OR UPDATE OR DELETE ON public.community_members
    FOR EACH ROW EXECUTE FUNCTION update_community_member_count();

-- Function to generate community slug
CREATE OR REPLACE FUNCTION generate_community_slug()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.slug IS NULL OR NEW.slug = '' THEN
        NEW.slug := lower(regexp_replace(NEW.name, '[^a-zA-Z0-9]+', '-', 'g'));
        NEW.slug := trim(both '-' from NEW.slug);
        
        -- Ensure uniqueness
        WHILE EXISTS (SELECT 1 FROM public.community WHERE slug = NEW.slug AND id != NEW.id) LOOP
            NEW.slug := NEW.slug || '-' || substr(md5(random()::text), 1, 6);
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_community_slug_trigger
    BEFORE INSERT OR UPDATE ON public.community
    FOR EACH ROW EXECUTE FUNCTION generate_community_slug();

-- Function to auto-update quest completion count
CREATE OR REPLACE FUNCTION update_quest_completion_count()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'completed' AND (OLD.status IS NULL OR OLD.status != 'completed') THEN
        UPDATE public.quests
        SET current_completions = current_completions + 1
        WHERE id = NEW.quest_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_quest_completed
    AFTER INSERT OR UPDATE ON public.user_quest_progress
    FOR EACH ROW EXECUTE FUNCTION update_quest_completion_count();

-- ============================================
-- REALTIME SUBSCRIPTIONS
-- ============================================

-- Enable realtime for specific tables
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_wallets;
ALTER PUBLICATION supabase_realtime ADD TABLE public.transactions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_quest_progress;
ALTER PUBLICATION supabase_realtime ADD TABLE public.community_members;

-- ============================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================

-- Insert sample quests
INSERT INTO public.quests (title, description, type, rarity, difficulty, reward_sparks, xp_reward, objectives, is_active, is_featured)
VALUES 
    ('Welcome Explorer', 'Complete your profile setup and start your journey!', 'story', 'common', 'easy', 50, 100,
     '[{"id": "1", "description": "Add a profile picture", "type": "complete_profile", "target_count": 1, "current_count": 0}, {"id": "2", "description": "Write a bio", "type": "add_bio", "target_count": 1, "current_count": 0}]', 
     true, true),
    
    ('Social Butterfly', 'Connect with the community by sending messages', 'daily', 'common', 'easy', 25, 50,
     '[{"id": "1", "description": "Send your first message", "type": "send_message", "target_count": 1, "current_count": 0}]', 
     true, false),
    
    ('Community Explorer', 'Discover and join different communities', 'weekly', 'rare', 'medium', 100, 200,
     '[{"id": "1", "description": "Join 3 different communities", "type": "join_community", "target_count": 3, "current_count": 0}]', 
     true, true),
    
    ('Quest Master', 'Complete 10 daily quests', 'achievement', 'epic', 'hard', 500, 1000,
     '[{"id": "1", "description": "Complete daily quests", "type": "complete_quests", "target_count": 10, "current_count": 0}]', 
     true, false),
    
    ('Generous Giver', 'Send Sparks to other users', 'weekly', 'uncommon', 'medium', 75, 150,
     '[{"id": "1", "description": "Transfer Sparks to 5 different users", "type": "transfer_currency", "target_count": 5, "current_count": 0}]', 
     true, false)
ON CONFLICT DO NOTHING;


-- Create sample communities (commented out - requires existing users)
-- After creating your first user, you can run this with a valid owner_id:
-- INSERT INTO public.community (name, description, sector_type, is_public, is_verified, owner_id)
-- VALUES 
--     ('Monocle Explorers', 'The official community for all Monocle users! Share tips, connect, and grow together.', 'general', true, true, 'YOUR_USER_ID_HERE'),
--     ('Tech Innovators', 'A community for technology enthusiasts and developers', 'tech', true, false, 'YOUR_USER_ID_HERE'),
--     ('Gaming Hub', 'Connect with fellow gamers and discuss your favorite games', 'gaming', true, false, 'YOUR_USER_ID_HERE')
-- ON CONFLICT DO NOTHING;


COMMIT;
