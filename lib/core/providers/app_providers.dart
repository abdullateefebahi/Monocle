import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/wallet_model.dart';

/// Auth state provider - tracks current authentication status
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseService.instance.authStateChanges;
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return SupabaseService.instance.currentUser;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// User profile provider
final userProfileProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final profile = await SupabaseService.instance.getProfile(user.id);
  if (profile == null) return null;

  return UserModel(
    id: profile['id'],
    email: profile['email'],
    username: profile['username'],
    displayName: profile['display_name'],
    avatarUrl: profile['avatar_url'],
    bio: profile['bio'],
    professionTag: profile['profession_tag'],
    createdAt: DateTime.parse(profile['created_at']),
    updatedAt: profile['updated_at'] != null
        ? DateTime.parse(profile['updated_at'])
        : null,
    isVerified: profile['is_verified'] ?? false,
    isOnboardingComplete: profile['is_onboarding_complete'] ?? false,
    level: profile['level'] ?? 1,
  );
});

/// Wallet provider - manages user's currency balances
final walletProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<WalletModel?>>((ref) {
      return WalletNotifier(ref);
    });

class WalletNotifier extends StateNotifier<AsyncValue<WalletModel?>> {
  final Ref _ref;
  RealtimeChannel? _subscription;

  WalletNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = const AsyncValue.data(null);
      return;
    }

    await loadWallet();
    _subscribeToUpdates(user.id);
  }

  Future<void> loadWallet() async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final walletData = await SupabaseService.instance.getWallet(user.id);
      if (walletData == null) {
        // Initialize wallet for new user
        await SupabaseService.instance.initializeWallet(user.id);
        final newWallet = await SupabaseService.instance.getWallet(user.id);
        state = AsyncValue.data(_mapToWallet(newWallet));
      } else {
        state = AsyncValue.data(_mapToWallet(walletData));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  WalletModel? _mapToWallet(Map<String, dynamic>? data) {
    if (data == null) return null;
    return WalletModel.fromJson(data);
  }

  void _subscribeToUpdates(String userId) {
    _subscription?.unsubscribe();
    _subscription = SupabaseService.instance.subscribeToWallet(userId, (data) {
      state = AsyncValue.data(_mapToWallet(data));
    });
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }
}

/// Theme mode provider
enum AppThemeMode { light, dark, system }

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
      return ThemeModeNotifier();
    });

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.system);

  void setThemeMode(AppThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    if (state == AppThemeMode.light) {
      state = AppThemeMode.dark;
    } else {
      state = AppThemeMode.light;
    }
  }
}

/// Loading state provider for async operations
final isLoadingProvider = StateProvider<bool>((ref) => false);

/// Error message provider
final errorMessageProvider = StateProvider<String?>((ref) => null);
