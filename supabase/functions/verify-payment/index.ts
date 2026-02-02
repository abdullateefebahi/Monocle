// Supabase Edge Function: Verify Paystack Payment
// Deploy with: supabase functions deploy verify-payment

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { reference, user_id, amount, currency } = await req.json();

    if (!reference || !user_id || !amount) {
      return new Response(
        JSON.stringify({ success: false, error: "Missing required fields" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 1. Verify with Paystack API
    const paystackSecretKey = Deno.env.get("PAYSTACK_SECRET_KEY");
    if (!paystackSecretKey) {
      throw new Error("PAYSTACK_SECRET_KEY not configured");
    }

    const verifyRes = await fetch(
      `https://api.paystack.co/transaction/verify/${reference}`,
      {
        headers: {
          Authorization: `Bearer ${paystackSecretKey}`,
        },
      }
    );

    const paystackData = await verifyRes.json();

    if (!paystackData.status || paystackData.data.status !== "success") {
      return new Response(
        JSON.stringify({ success: false, error: "Payment verification failed", details: paystackData }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 2. Verify amount matches (Paystack returns amount in kobo, so divide by 100)
    const paidAmountNaira = paystackData.data.amount / 100;
    
    // 3. Connect to Supabase
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // 4. Check if this reference has already been used (prevent double-crediting)
    const { data: existingTx } = await supabase
      .from("transactions")
      .select("id")
      .eq("reference", reference)
      .single();

    if (existingTx) {
      return new Response(
        JSON.stringify({ success: false, error: "Transaction already processed" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 5. Credit the user's wallet
    // Calculate sparks: e.g., 1 Naira = 10 Sparks (adjust your rate)
    const sparksToCredit = Math.floor(paidAmountNaira * 10);
    
    // Update wallet balance
    const { error: walletError } = await supabase.rpc("add_sparks_to_wallet", {
      p_user_id: user_id,
      p_amount: sparksToCredit,
    });

    if (walletError) {
      console.error("Wallet update error:", walletError);
      // Log the transaction as failed
      await supabase.from("transactions").insert({
        user_id: user_id,
        type: "deposit",
        amount: sparksToCredit,
        currency: currency || "sparks",
        status: "failed",
        reference: reference,
        description: `Paystack deposit - ${paidAmountNaira} NGN`,
      });
      
      throw new Error("Failed to credit wallet");
    }

    // 6. Record the successful transaction
    await supabase.from("transactions").insert({
      user_id: user_id,
      type: "deposit",
      amount: sparksToCredit,
      currency: currency || "sparks",
      status: "completed",
      reference: reference,
      description: `Paystack deposit - ${paidAmountNaira} NGN`,
      metadata: { paystack_reference: reference, amount_ngn: paidAmountNaira },
    });

    return new Response(
      JSON.stringify({
        success: true,
        message: `Successfully credited ${sparksToCredit} Sparks`,
        sparks_credited: sparksToCredit,
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Error:", error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
