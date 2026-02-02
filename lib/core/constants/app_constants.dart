import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App-wide constants for Project Monocle
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Monocle';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Connect. Engage. Earn.';

  // Supabase Configuration
  // 1. Try .env file
  // 2. Try --dart-define (compile time)
  // 3. Throw error (or use placeholder for safe failure)
  static String get supabaseUrl {
    final envUrl = dotenv.env['SUPABASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    const dartDefineUrl = String.fromEnvironment('SUPABASE_URL');
    if (dartDefineUrl.isNotEmpty) {
      return dartDefineUrl;
    }
    return 'https://placeholder.supabase.co'; // Fallback to prevent startup crash
  }

  static String get supabaseAnonKey {
    final envKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }
    const dartDefineKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (dartDefineKey.isNotEmpty) {
      return dartDefineKey;
    }
    return 'placeholder-key';
  }

  // Go Backend API
  static String get goApiBaseUrl {
    final envUrl = dotenv.env['GO_API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    const dartDefineUrl = String.fromEnvironment('GO_API_BASE_URL');
    if (dartDefineUrl.isNotEmpty) {
      return dartDefineUrl;
    }
    return 'http://localhost:8080';
  }

  // Currency Names
  static const String softCurrencyName = 'Shards';
  static const String hardCurrencyName = 'Orbs';
  static const String softCurrencySymbol = '⚡';
  static const String hardCurrencySymbol = '🔮';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Durations
  static const Duration shortCache = Duration(minutes: 5);
  static const Duration mediumCache = Duration(minutes: 30);
  static const Duration longCache = Duration(hours: 2);

  // Community Limits
  static const int maxCommunityMembers = 10000;
  static const int maxCommunityRoles = 50;
  static const int maxChannelsPerCommunity = 100;

  // Quest Limits
  static const int maxActiveQuests = 10;
  static const int maxDailyMissions = 5;

  // Profile Limits
  static const int maxBioLength = 500;
  static const int maxUsernameLength = 30;

  static const int minUsernameLength = 3;

  // Global Community ID
  static const String globalCommunityId =
      '00000000-0000-0000-0000-000000000000'; // Default Global ID
}

/// API Endpoints for Go Backend
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String validateToken = '/auth/validate';
  static const String refreshToken = '/auth/refresh';

  // Users
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String userWallet = '/users/wallet';

  // Transactions
  static const String transactions = '/transactions';
  static const String transfer = '/transactions/transfer';
  static const String transactionHistory = '/transactions/history';

  // Communities
  static const String communities = '/communities';
  static const String joinCommunity = '/communities/join';
  static const String leaveCommunity = '/communities/leave';

  // Quests
  static const String quests = '/quests';
  static const String activeQuests = '/quests/active';
  static const String completeQuest = '/quests/complete';
  static const String claimReward = '/quests/claim';

  // Missions
  static const String missions = '/missions';
  static const String dailyMissions = '/missions/daily';

  // Events
  static const String events = '/events';
  static const String activeEvents = '/events/active';

  // Chat
  static const String messages = '/messages';
  static const String channels = '/channels';
}

/// Storage Keys for local persistence
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userProfile = 'user_profile';
  static const String themeMode = 'theme_mode';
  static const String onboardingComplete = 'onboarding_complete';
  static const String lastSyncTime = 'last_sync_time';
  static const String cachedWallet = 'cached_wallet';
  static const String fcmToken = 'fcm_token';
}
