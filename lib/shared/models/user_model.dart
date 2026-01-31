import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// User profile model for Monocle
@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final String? professionTag;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isVerified;
  final bool isOnboardingComplete;
  final UserStats stats;

  const UserModel({
    required this.id,
    required this.email,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.professionTag,
    required this.createdAt,
    this.updatedAt,
    this.isVerified = false,
    this.isOnboardingComplete = false,
    this.stats = const UserStats(),
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? professionTag,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isOnboardingComplete,
    UserStats? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      professionTag: professionTag ?? this.professionTag,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    displayName,
    avatarUrl,
    bio,
    professionTag,
    createdAt,
    updatedAt,
    isVerified,
    isOnboardingComplete,
    stats,
  ];
}

/// User statistics
@JsonSerializable()
class UserStats extends Equatable {
  final int totalSparks;
  final int totalOrbs;
  final int communitiesJoined;
  final int questsCompleted;
  final int missionsCompleted;
  final int totalTransactions;
  final int reputation;

  const UserStats({
    this.totalSparks = 0,
    this.totalOrbs = 0,
    this.communitiesJoined = 0,
    this.questsCompleted = 0,
    this.missionsCompleted = 0,
    this.totalTransactions = 0,
    this.reputation = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  @override
  List<Object?> get props => [
    totalSparks,
    totalOrbs,
    communitiesJoined,
    questsCompleted,
    missionsCompleted,
    totalTransactions,
    reputation,
  ];
}
