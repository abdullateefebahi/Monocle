-- ================================================================
-- MONOCLE FEATURES SETUP: TRANSACTIONS & CHAT
-- ================================================================

BEGIN;

-- 1. TRANSACTIONS TABLE
-- Stores wallet history (deposit, withdrawal, transfer, quest_reward, etc.)
CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    type TEXT NOT NULL CHECK (type IN ('deposit', 'withdrawal', 'transfer', 'quest_reward', 'daily_bonus', 'purchase')),
    amount INTEGER NOT NULL,
    currency TEXT NOT NULL CHECK (currency IN ('sparks', 'orbs')),
    status TEXT NOT NULL DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'failed')),
    reference TEXT, -- Payment gateway reference (e.g., Paystack ref)
    description TEXT,
    related_user_id UUID REFERENCES auth.users(id), -- For transfers (sender/receiver)
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast history lookup
CREATE INDEX IF NOT EXISTS idx_transactions_user ON public.transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON public.transactions(created_at);

-- RLS for Transactions
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own transactions"
    ON public.transactions FOR SELECT
    USING (auth.uid() = user_id);

-- Only system/functions can insert (usually), but for now allow authenticated for simple transfers
-- In production, transfers should be handled via Database Function to ensure atomicity
CREATE POLICY "Users can insert their own transactions (e.g. transfers)"
    ON public.transactions FOR INSERT
    WITH CHECK (auth.uid() = user_id);


-- 2. CHAT MESSAGES TABLE
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID NOT NULL REFERENCES public.community(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES auth.users(id),
    content TEXT NOT NULL CHECK (char_length(content) > 0),
    type TEXT DEFAULT 'text' CHECK (type IN ('text', 'image', 'system')),
    reply_to_id UUID REFERENCES public.messages(id),
    is_edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fetching chat history
CREATE INDEX IF NOT EXISTS idx_messages_community ON public.messages(community_id, created_at DESC);

-- RLS for Messages
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Anyone in the community can view messages (simplified: anyone authenticated for public/sector communities)
CREATE POLICY "View messages if authenticated"
    ON public.messages FOR SELECT
    USING (auth.role() = 'authenticated');

-- Users can send messages
CREATE POLICY "Insert messages if authenticated"
    ON public.messages FOR INSERT
    WITH CHECK (auth.uid() = sender_id);

-- Users can update/delete ONLY their own messages
CREATE POLICY "Edit own messages"
    ON public.messages FOR UPDATE
    USING (auth.uid() = sender_id);

CREATE POLICY "Delete own messages"
    ON public.messages FOR DELETE
    USING (auth.uid() = sender_id);


-- 3. ENABLE REALTIME FOR CHAT
-- This allows Flutter to subscribe to new messages instantly
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;

COMMIT;
