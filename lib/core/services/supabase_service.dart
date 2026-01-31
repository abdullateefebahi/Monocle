import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

/// Supabase service singleton for authentication and database operations
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseClient get client => Supabase.instance.client;

  SupabaseService._();

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    if (kDebugMode) {
      print('Supabase initialized successfully');
    }
  }

  // ============ AUTH GETTERS ============
  GoTrueClient get auth => client.auth;
  User? get currentUser => auth.currentUser;
  String? get currentUserId => currentUser?.id;
  bool get isAuthenticated => currentUser != null;
  Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ============ AUTH METHODS ============

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await auth.signUp(email: email, password: password, data: data);
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(email: email, password: password);
  }

  /// Sign in with OAuth provider (Google, Apple, etc.)
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    return await auth.signInWithOAuth(
      provider,
      redirectTo: kIsWeb ? null : 'io.monocle.app://login-callback/',
    );
  }

  /// Sign in with magic link (passwordless)
  Future<void> signInWithMagicLink({required String email}) async {
    await auth.signInWithOtp(
      email: email,
      emailRedirectTo: kIsWeb ? null : 'io.monocle.app://login-callback/',
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    await auth.resetPasswordForEmail(
      email,
      redirectTo: kIsWeb ? null : 'io.monocle.app://reset-password/',
    );
  }

  /// Update password
  Future<UserResponse> updatePassword({required String newPassword}) async {
    return await auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> data) async {
    return await auth.updateUser(UserAttributes(data: data));
  }

  /// Refresh session
  Future<AuthResponse> refreshSession() async {
    return await auth.refreshSession();
  }

  // ============ DATABASE HELPERS ============

  /// Get a reference to a table
  SupabaseQueryBuilder from(String table) => client.from(table);

  /// Get storage bucket
  StorageFileApi storage(String bucket) => client.storage.from(bucket);

  /// Get realtime channel
  RealtimeChannel channel(String name) => client.channel(name);

  // ============ PROFILE OPERATIONS ============

  /// Get user profile
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await from(
      'profiles',
    ).select().eq('id', userId).maybeSingle();
    return response;
  }

  /// Update user profile
  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await from('profiles').upsert({
      'id': userId,
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Create initial profile after signup
  Future<void> createProfile(String userId, String email) async {
    await from('profiles').insert({
      'id': userId,
      'email': email,
      'created_at': DateTime.now().toIso8601String(),
      'is_onboarding_complete': false,
    });
  }

  // ============ WALLET OPERATIONS ============

  /// Get user wallet
  Future<Map<String, dynamic>?> getWallet(String userId) async {
    final response = await from(
      'wallets',
    ).select().eq('user_id', userId).maybeSingle();
    return response;
  }

  /// Initialize wallet for new user
  Future<void> initializeWallet(String userId) async {
    await from('wallets').insert({
      'user_id': userId,
      'shard_balance': 100, // Welcome bonus
      'orb_balance': 0,
      'last_updated': DateTime.now().toIso8601String(),
    });
  }

  // ============ TRANSACTIONS ============

  /// Get transaction history
  Future<List<Map<String, dynamic>>> getTransactions(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await from('transactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    return List<Map<String, dynamic>>.from(response);
  }

  // ============ REALTIME SUBSCRIPTIONS ============

  /// Subscribe to wallet changes
  RealtimeChannel subscribeToWallet(
    String userId,
    void Function(Map<String, dynamic>) onUpdate,
  ) {
    return channel('wallet:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'wallets',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .subscribe();
  }

  /// Subscribe to new transactions
  RealtimeChannel subscribeToTransactions(
    String userId,
    void Function(Map<String, dynamic>) onNewTransaction,
  ) {
    return channel('transactions:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'transactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => onNewTransaction(payload.newRecord),
        )
        .subscribe();
  }
}
