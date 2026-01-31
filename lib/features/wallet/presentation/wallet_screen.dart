import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/wallet_model.dart';
import '../data/wallet_repository.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsyncValue = ref.watch(walletStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: walletAsyncValue.when(
          data: (wallet) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildBalanceSection(wallet),
                  const SizedBox(height: 32),
                  _buildDailyBonusSection(context, ref, wallet),
                  const SizedBox(height: 32),
                  // Placeholder for future transaction history
                  /*
                  Text(
                    'Recent Transactions',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEmptyState(),
                  */
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.cyanAccent),
          ),
          error: (err, stack) => Center(
            child: Text(
              'Error loading wallet: $err',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Wallet',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your earnings and rewards',
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBalanceSection(WalletModel wallet) {
    return Column(
      children: [
        _buildCurrencyCard(
          title: 'Shards Balance',
          amount: wallet.sparkBalance,
          icon: Icons.flash_on,
          color: AppColors.cyanAccent,
          gradientColors: [
            AppColors.cyanAccent.withValues(alpha: 0.2),
            AppColors.cyanAccent.withValues(alpha: 0.05),
          ],
        ),
        const SizedBox(height: 16),
        _buildCurrencyCard(
          title: 'Orbs Balance',
          amount: wallet.orbBalance,
          icon: Icons.circle,
          color: AppColors.royalPurple,
          gradientColors: [
            AppColors.royalPurple.withValues(alpha: 0.2),
            AppColors.royalPurple.withValues(alpha: 0.05),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyCard({
    required String title,
    required int amount,
    required IconData icon,
    required Color color,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            amount.toString(),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyBonusSection(
    BuildContext context,
    WidgetRef ref,
    WalletModel wallet,
  ) {
    // Check if bonus is available
    final lastClaim = wallet.lastDailyBonusAt;
    final now = DateTime.now();
    bool canClaim = true;

    if (lastClaim != null) {
      final today = DateTime(now.year, now.month, now.day);
      final claimDate = DateTime(
        lastClaim.year,
        lastClaim.month,
        lastClaim.day,
      );
      if (claimDate.isAtSameMomentAs(today)) {
        canClaim = false;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Bonus',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  canClaim ? 'Ready to claim!' : 'Come back tomorrow',
                  style: TextStyle(
                    color: canClaim
                        ? AppColors.cyanAccent
                        : AppColors.textSecondaryDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: canClaim
                ? () async {
                    try {
                      // We don't need user ID here as repository provider handles it?
                      // Wait, repository methods usually need ID or the provider handles it.
                      // Let's check repository. Ah, repository method `claimDailyBonus` needs userId.
                      // We can get userId from wallet.userId
                      final repo = ref.read(walletRepositoryProvider);
                      await repo.claimDailyBonus(wallet.userId);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Daily bonus claimed! +50 Sparks'),
                            backgroundColor: AppColors.cyanAccent,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to claim bonus: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyanAccent,
              disabledBackgroundColor: AppColors.cyanAccent.withValues(
                alpha: 0.1,
              ),
              foregroundColor: AppColors.backgroundDark,
              disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Claim'),
          ),
        ],
      ),
    );
  }
}
