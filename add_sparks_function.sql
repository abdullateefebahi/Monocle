-- ================================================================
-- HELPER FUNCTION: Add Sparks to Wallet
-- ================================================================
-- This function is called by the Edge Function to credit sparks

CREATE OR REPLACE FUNCTION add_sparks_to_wallet(p_user_id UUID, p_amount INTEGER)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE public.user_wallets
    SET 
        spark_balance = spark_balance + p_amount,
        lifetime_sparks_earned = lifetime_sparks_earned + p_amount
    WHERE user_id = p_user_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Wallet not found for user %', p_user_id;
    END IF;
END;
$$;
