import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../shared/models/wallet_model.dart';
import '../../../core/providers/app_providers.dart';

// Repository
class WalletRepository {
  final SupabaseClient _supabase;

  WalletRepository(this._supabase);

  // Stream wallet data (Real-time updates)
  Stream<WalletModel> streamWallet(String userId) {
    return _supabase
        .from('user_wallets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) {
          if (data.isEmpty) {
            // Should create wallet via trigger, but handle empty case just in case
            throw Exception('Wallet not found');
          }
          return WalletModel.fromJson(data.first);
        });
  }

  // Claim Daily Bonus
  Future<Map<String, dynamic>> claimDailyBonus(String userId) async {
    try {
      final response = await _supabase.rpc(
        'claim_daily_bonus',
        params: {'p_user_id': userId},
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to claim bonus: $e');
    }
  }
}

// Providers
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(SupabaseService.client);
});

// Real-time Wallet Provider
final walletStreamProvider = StreamProvider.autoDispose<WalletModel>((ref) {
  final repository = ref.watch(walletRepositoryProvider);

  // Watch auth state to get current user ID
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return const Stream.empty();
  }

  return repository.streamWallet(user.id);
});
