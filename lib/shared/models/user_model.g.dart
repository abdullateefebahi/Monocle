// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String?,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  bio: json['bio'] as String?,
  professionTag: json['professionTag'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  isVerified: json['isVerified'] as bool? ?? false,
  isOnboardingComplete: json['isOnboardingComplete'] as bool? ?? false,
  level: (json['level'] as num?)?.toInt() ?? 1,
  stats: json['stats'] == null
      ? const UserStats()
      : UserStats.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'bio': instance.bio,
  'professionTag': instance.professionTag,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'isVerified': instance.isVerified,
  'isOnboardingComplete': instance.isOnboardingComplete,
  'level': instance.level,
  'stats': instance.stats,
};

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
  totalSparks: (json['totalSparks'] as num?)?.toInt() ?? 0,
  totalOrbs: (json['totalOrbs'] as num?)?.toInt() ?? 0,
  communitiesJoined: (json['communitiesJoined'] as num?)?.toInt() ?? 0,
  questsCompleted: (json['questsCompleted'] as num?)?.toInt() ?? 0,
  missionsCompleted: (json['missionsCompleted'] as num?)?.toInt() ?? 0,
  totalTransactions: (json['totalTransactions'] as num?)?.toInt() ?? 0,
  reputation: (json['reputation'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
  'totalSparks': instance.totalSparks,
  'totalOrbs': instance.totalOrbs,
  'communitiesJoined': instance.communitiesJoined,
  'questsCompleted': instance.questsCompleted,
  'missionsCompleted': instance.missionsCompleted,
  'totalTransactions': instance.totalTransactions,
  'reputation': instance.reputation,
};
