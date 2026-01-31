-- ================================================================
-- FIX FOR INFINITE RECURSION ERROR (Code: 42P17)
-- ================================================================
-- Run this script in your Supabase SQL Editor to fix the
-- "infinite recursion detected in policy" error on the community table.

-- 1. Create a secure function to check membership 
-- This function runs with SECURITY DEFINER privileges to bypass RLS loops
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

-- 2. Drop the problematic policy that causes the recursion
DROP POLICY IF EXISTS "Community members can view their communities" ON public.community;

-- 3. Re-create the policy using the secure function
CREATE POLICY "Community members can view their communities"
    ON public.community FOR SELECT
    USING (
        is_community_member(id)
    );
