import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'supabase_service.dart';

class PaystackService {
  static String get _publicKey => dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '';

  /// Initialize a Paystack transaction and return the checkout URL
  /// This uses Paystack's API to create a transaction
  static Future<Map<String, dynamic>?> initializeTransaction({
    required String email,
    required int amountInKobo, // 100 kobo = 1 Naira
    required String userId,
  }) async {
    // Note: In production, this API call should be made from your backend
    // to keep your secret key secure. For now, we'll use the Edge Function.

    try {
      final response = await SupabaseService.client.functions.invoke(
        'initialize-payment',
        body: {
          'email': email,
          'amount': amountInKobo,
          'user_id': userId,
        },
      );

      if (response.status == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Paystack init error: $e');
      return null;
    }
  }

  /// Open Paystack checkout in browser
  static Future<bool> openCheckout(String checkoutUrl) async {
    final uri = Uri.parse(checkoutUrl);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Verify payment with Edge Function and credit wallet
  static Future<Map<String, dynamic>> verifyAndCreditWallet({
    required String reference,
    required String userId,
    required int amount,
  }) async {
    try {
      final response = await SupabaseService.client.functions.invoke(
        'verify-payment',
        body: {
          'reference': reference,
          'user_id': userId,
          'amount': amount,
          'currency': 'sparks',
        },
      );

      if (response.status != 200) {
        final error = response.data?['error'] ?? 'Unknown error';
        return {'success': false, 'error': error};
      }

      return {
        'success': true,
        'sparks_credited': response.data?['sparks_credited'] ?? 0,
        'message': response.data?['message'] ?? 'Payment successful',
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Generate a unique reference
  static String generateReference() {
    return 'MONOCLE_${DateTime.now().millisecondsSinceEpoch}';
  }
}

/// Simple dialog to collect amount for funding
class FundWalletDialog extends StatefulWidget {
  final String userEmail;
  final String userId;
  final Function(int sparksAdded) onSuccess;

  const FundWalletDialog({
    super.key,
    required this.userEmail,
    required this.userId,
    required this.onSuccess,
  });

  @override
  State<FundWalletDialog> createState() => _FundWalletDialogState();
}

class _FundWalletDialogState extends State<FundWalletDialog> {
  int _selectedAmount = 1000; // Default 1000 Naira
  bool _isLoading = false;

  final List<int> _amounts = [500, 1000, 2000, 5000, 10000];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E2E),
      title: const Text(
        'Fund Wallet',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select amount (₦)',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amounts.map((amount) {
              final isSelected = amount == _selectedAmount;
              return ChoiceChip(
                label: Text('₦$amount'),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedAmount = amount);
                },
                selectedColor: const Color(0xFF00D9FF),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: const Color(0xFF2D2D3D),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'You will get ${_selectedAmount * 10} Sparks',
            style: const TextStyle(color: Color(0xFF00D9FF), fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handlePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D9FF),
            foregroundColor: Colors.black,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.black),
                )
              : const Text('Pay with Paystack'),
        ),
      ],
    );
  }

  Future<void> _handlePayment() async {
    setState(() => _isLoading = true);

    // For now, show a message that this requires backend setup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Deploy the Edge Functions first. See console for instructions.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 4),
      ),
    );

    debugPrint('''
╔══════════════════════════════════════════════════════════════╗
║                    PAYSTACK SETUP                              ║
╠══════════════════════════════════════════════════════════════╣
║ 1. Run SQL: add_sparks_function.sql in Supabase              ║
║ 2. Set secrets in Supabase:                                    ║
║    supabase secrets set PAYSTACK_SECRET_KEY=sk_test_xxx       ║
║ 3. Deploy Edge Function:                                       ║
║    supabase functions deploy verify-payment                   ║
║ 4. Add PAYSTACK_PUBLIC_KEY to your .env file                 ║
╚══════════════════════════════════════════════════════════════╝
    ''');

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }
}
