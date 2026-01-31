-- ==========================================
-- AUTO-CREATE WALLET & BONUS FOR NEW USERS
-- ==========================================
-- This script adds a trigger to automatically create a wallet
-- and give 100 sparks to new users when they authenticate

-- ==========================================
-- TRIGGER FUNCTION: Create Wallet & Give Welcome Bonus
-- ==========================================

CREATE OR REPLACE FUNCTION create_wallet_and_welcome_bonus()
RETURNS TRIGGER AS $$
BEGIN
  -- Create wallet for new user with welcome bonus
  INSERT INTO public.user_wallets (
    user_id,
    spark_balance,
    orb_balance,
    lifetime_sparks_earned,
    lifetime_orbs_earned
  ) VALUES (
    NEW.id,
    100,  -- Welcome bonus: 100 sparks
    0,    -- No orbs initially
    100,  -- Track that they've earned 100 sparks
    0
  );
  
  RETURN NEW;
EXCEPTION
  WHEN unique_violation THEN
    -- Wallet already exists, do nothing
    RETURN NEW;
  WHEN OTHERS THEN
    -- Log error but don't fail user creation
    RAISE WARNING 'Failed to create wallet for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- TRIGGER: Auto-Create Wallet on User Signup
-- ==========================================

DROP TRIGGER IF EXISTS on_auth_user_created_wallet ON auth.users;
CREATE TRIGGER on_auth_user_created_wallet
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION create_wallet_and_welcome_bonus();

-- ==========================================
-- HELPER FUNCTION: Add Sparks
-- ==========================================

CREATE OR REPLACE FUNCTION add_sparks(
  p_user_id UUID,
  p_amount INTEGER,
  p_reason TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
  v_new_balance INTEGER;
  v_new_lifetime INTEGER;
BEGIN
  -- Update wallet
  UPDATE public.user_wallets
  SET 
    spark_balance = spark_balance + p_amount,
    lifetime_sparks_earned = lifetime_sparks_earned + p_amount,
    last_updated = NOW()
  WHERE user_id = p_user_id
  RETURNING spark_balance, lifetime_sparks_earned 
  INTO v_new_balance, v_new_lifetime;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Wallet not found for user %', p_user_id;
  END IF;
  
  RETURN jsonb_build_object(
    'success', true,
    'new_balance', v_new_balance,
    'lifetime_earned', v_new_lifetime,
    'amount_added', p_amount,
    'reason', p_reason
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- HELPER FUNCTION: Spend Sparks
-- ==========================================

CREATE OR REPLACE FUNCTION spend_sparks(
  p_user_id UUID,
  p_amount INTEGER,
  p_reason TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
  v_current_balance INTEGER;
  v_new_balance INTEGER;
BEGIN
  -- Get current balance
  SELECT spark_balance INTO v_current_balance
  FROM public.user_wallets
  WHERE user_id = p_user_id;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Wallet not found for user %', p_user_id;
  END IF;
  
  -- Check sufficient balance
  IF v_current_balance < p_amount THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Insufficient sparks',
      'current_balance', v_current_balance,
      'required', p_amount
    );
  END IF;
  
  -- Deduct sparks
  UPDATE public.user_wallets
  SET 
    spark_balance = spark_balance - p_amount,
    last_updated = NOW()
  WHERE user_id = p_user_id
  RETURNING spark_balance INTO v_new_balance;
  
  RETURN jsonb_build_object(
    'success', true,
    'new_balance', v_new_balance,
    'amount_spent', p_amount,
    'reason', p_reason
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- HELPER FUNCTION: Add Orbs
-- ==========================================

CREATE OR REPLACE FUNCTION add_orbs(
  p_user_id UUID,
  p_amount INTEGER,
  p_reason TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
  v_new_balance INTEGER;
  v_new_lifetime INTEGER;
BEGIN
  -- Update wallet
  UPDATE public.user_wallets
  SET 
    orb_balance = orb_balance + p_amount,
    lifetime_orbs_earned = lifetime_orbs_earned + p_amount,
    last_updated = NOW()
  WHERE user_id = p_user_id
  RETURNING orb_balance, lifetime_orbs_earned 
  INTO v_new_balance, v_new_lifetime;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Wallet not found for user %', p_user_id;
  END IF;
  
  RETURN jsonb_build_object(
    'success', true,
    'new_balance', v_new_balance,
    'lifetime_earned', v_new_lifetime,
    'amount_added', p_amount,
    'reason', p_reason
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- HELPER FUNCTION: Spend Orbs
-- ==========================================

CREATE OR REPLACE FUNCTION spend_orbs(
  p_user_id UUID,
  p_amount INTEGER,
  p_reason TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
  v_current_balance INTEGER;
  v_new_balance INTEGER;
BEGIN
  -- Get current balance
  SELECT orb_balance INTO v_current_balance
  FROM public.user_wallets
  WHERE user_id = p_user_id;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Wallet not found for user %', p_user_id;
  END IF;
  
  -- Check sufficient balance
  IF v_current_balance < p_amount THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Insufficient orbs',
      'current_balance', v_current_balance,
      'required', p_amount
    );
  END IF;
  
  -- Deduct orbs
  UPDATE public.user_wallets
  SET 
    orb_balance = orb_balance - p_amount,
    last_updated = NOW()
  WHERE user_id = p_user_id
  RETURNING orb_balance INTO v_new_balance;
  
  RETURN jsonb_build_object(
    'success', true,
    'new_balance', v_new_balance,
    'amount_spent', p_amount,
    'reason', p_reason
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- HELPER FUNCTION: Claim Daily Bonus
-- ==========================================

CREATE OR REPLACE FUNCTION claim_daily_bonus(p_user_id UUID)
RETURNS JSONB AS $$
DECLARE
  v_last_claimed TIMESTAMPTZ;
  v_daily_bonus_amount INTEGER := 50; -- Daily bonus: 50 sparks
  v_new_balance INTEGER;
BEGIN
  -- Get last claim time
  SELECT last_daily_bonus_at INTO v_last_claimed
  FROM public.user_wallets
  WHERE user_id = p_user_id;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Wallet not found for user %', p_user_id;
  END IF;
  
  -- Check if already claimed today
  IF v_last_claimed IS NOT NULL 
     AND v_last_claimed::DATE = CURRENT_DATE THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Daily bonus already claimed today',
      'next_claim_at', (v_last_claimed + INTERVAL '1 day')::DATE
    );
  END IF;
  
  -- Give daily bonus
  UPDATE public.user_wallets
  SET 
    spark_balance = spark_balance + v_daily_bonus_amount,
    lifetime_sparks_earned = lifetime_sparks_earned + v_daily_bonus_amount,
    last_daily_bonus_at = NOW(),
    last_updated = NOW()
  WHERE user_id = p_user_id
  RETURNING spark_balance INTO v_new_balance;
  
  RETURN jsonb_build_object(
    'success', true,
    'bonus_amount', v_daily_bonus_amount,
    'new_balance', v_new_balance,
    'next_claim_at', (CURRENT_DATE + INTERVAL '1 day')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- MIGRATION: Create Wallets for Existing Users
-- ==========================================

-- Run this once to create wallets for any existing users who don't have one
DO $$
DECLARE
  user_record RECORD;
  wallet_exists BOOLEAN;
BEGIN
  FOR user_record IN SELECT id FROM auth.users
  LOOP
    -- Check if wallet exists
    SELECT EXISTS (
      SELECT 1 FROM public.user_wallets WHERE user_id = user_record.id
    ) INTO wallet_exists;
    
    -- Create wallet if it doesn't exist
    IF NOT wallet_exists THEN
      INSERT INTO public.user_wallets (
        user_id,
        spark_balance,
        orb_balance,
        lifetime_sparks_earned,
        lifetime_orbs_earned
      ) VALUES (
        user_record.id,
        100, -- Welcome bonus
        0,
        100,
        0
      );
      
      RAISE NOTICE 'Created wallet for existing user %', user_record.id;
    END IF;
  END LOOP;
END $$;

-- ==========================================
-- USAGE EXAMPLES
-- ==========================================

-- Get user's wallet balance
-- SELECT spark_balance, orb_balance, lifetime_sparks_earned
-- FROM public.user_wallets
-- WHERE user_id = auth.uid();

-- Add sparks (reward user)
-- SELECT add_sparks(
--   'user-uuid-here',
--   50,
--   'Quest completion reward'
-- );

-- Spend sparks (purchase item)
-- SELECT spend_sparks(
--   'user-uuid-here',
--   25,
--   'Purchased avatar customization'
-- );

-- Add orbs (premium currency)
-- SELECT add_orbs(
--   'user-uuid-here',
--   10,
--   'In-app purchase'
-- );

-- Claim daily bonus
-- SELECT claim_daily_bonus(auth.uid());
