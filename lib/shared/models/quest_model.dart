import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quest_model.g.dart';

/// Quest rarity levels
enum QuestRarity {
  @JsonValue('common')
  common,
  @JsonValue('uncommon')
  uncommon,
  @JsonValue('rare')
  rare,
  @JsonValue('epic')
  epic,
  @JsonValue('legendary')
  legendary,
}

/// Quest status
enum QuestStatus {
  @JsonValue('available')
  available,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('claimed')
  claimed,
  @JsonValue('expired')
  expired,
}

/// Quest model for the gamification engine
@JsonSerializable()
class QuestModel extends Equatable {
  final String id;
  final String title;
  final String description;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  final QuestRarity rarity;
  final QuestType type;

  @JsonKey(name: 'reward_sparks', defaultValue: 0)
  final int rewardSparks;

  @JsonKey(name: 'reward_orbs', defaultValue: 0)
  final int rewardOrbs;

  @JsonKey(name: 'xp_reward', defaultValue: 0)
  final int xpReward;

  @JsonKey(defaultValue: [])
  final List<QuestObjective> objectives;

  @JsonKey(name: 'start_date')
  final DateTime? startDate;

  @JsonKey(name: 'end_date')
  final DateTime? endDate;

  @JsonKey(name: 'max_completions')
  final int? maxCompletions;

  @JsonKey(name: 'current_completions', defaultValue: 0)
  final int currentCompletions;

  @JsonKey(name: 'is_repeatable', defaultValue: false)
  final bool isRepeatable;

  @JsonKey(name: 'community_id')
  final String? communityId; // Should be AppConstants.globalCommunityId for global quests

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.iconUrl,
    this.rarity = QuestRarity.common,
    this.rewardSparks = 0,
    this.rewardOrbs = 0,
    this.xpReward = 0,
    required this.objectives,
    this.startDate,
    this.endDate,
    this.maxCompletions,
    this.currentCompletions = 0,
    this.isRepeatable = false,
    this.communityId,
    required this.createdAt,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) =>
      _$QuestModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuestModelToJson(this);

  bool get isActive {
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return true;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconUrl,
    rarity,
    type,
    rewardSparks,
    rewardOrbs,
    xpReward,
    objectives,
    startDate,
    endDate,
    maxCompletions,
    currentCompletions,
    isRepeatable,
    communityId,
    createdAt,
  ];
}

enum QuestType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('story')
  story,
  @JsonValue('event')
  event,
  @JsonValue('community')
  community,
  @JsonValue('global')
  global,
  @JsonValue('sector')
  sector,
  @JsonValue('mission')
  mission,
}

/// Quest objective
@JsonSerializable()
class QuestObjective extends Equatable {
  final String id;
  final String description;
  final ObjectiveType type;

  @JsonKey(name: 'target_count', defaultValue: 1)
  final int targetCount;

  @JsonKey(name: 'current_count', defaultValue: 0)
  final int currentCount;

  final Map<String, dynamic>? requirements;

  const QuestObjective({
    required this.id,
    required this.description,
    required this.type,
    required this.targetCount,
    this.currentCount = 0,
    this.requirements,
  });

  factory QuestObjective.fromJson(Map<String, dynamic> json) =>
      _$QuestObjectiveFromJson(json);
  Map<String, dynamic> toJson() => _$QuestObjectiveToJson(this);

  bool get isComplete => currentCount >= targetCount;
  double get progress => targetCount > 0 ? currentCount / targetCount : 0;

  @override
  List<Object?> get props => [
    id,
    description,
    type,
    targetCount,
    currentCount,
    requirements,
  ];
}

enum ObjectiveType {
  @JsonValue('send_message')
  sendMessage,
  @JsonValue('join_community')
  joinCommunity,
  @JsonValue('complete_profile')
  completeProfile,
  @JsonValue('make_transfer')
  makeTransfer,
  @JsonValue('invite_user')
  inviteUser,
  @JsonValue('earn_shards')
  earnShards,
  @JsonValue('spend_shards')
  spendShards,
  @JsonValue('login_streak')
  loginStreak,
  @JsonValue('custom')
  custom,
}

/// User's quest progress
@JsonSerializable()
class UserQuestProgress extends Equatable {
  final String id;
  final String questId;
  final String userId;
  final QuestStatus status;
  final List<QuestObjective> objectives;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime? claimedAt;

  const UserQuestProgress({
    required this.id,
    required this.questId,
    required this.userId,
    this.status = QuestStatus.active,
    required this.objectives,
    required this.startedAt,
    this.completedAt,
    this.claimedAt,
  });

  factory UserQuestProgress.fromJson(Map<String, dynamic> json) =>
      _$UserQuestProgressFromJson(json);
  Map<String, dynamic> toJson() => _$UserQuestProgressToJson(this);

  bool get isComplete => objectives.every((o) => o.isComplete);
  double get overallProgress {
    if (objectives.isEmpty) return 0;
    return objectives.map((o) => o.progress).reduce((a, b) => a + b) /
        objectives.length;
  }

  @override
  List<Object?> get props => [
    id,
    questId,
    userId,
    status,
    objectives,
    startedAt,
    completedAt,
    claimedAt,
  ];
}

/// Mission model (daily missions)
@JsonSerializable()
class MissionModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final int rewardSparks;
  final int rewardOrbs;
  final ObjectiveType objectiveType;
  final int targetCount;
  final int currentCount;
  final bool isComplete;
  final bool isClaimed;
  final DateTime availableUntil;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    this.rewardSparks = 0,
    this.rewardOrbs = 0,
    required this.objectiveType,
    required this.targetCount,
    this.currentCount = 0,
    this.isComplete = false,
    this.isClaimed = false,
    required this.availableUntil,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) =>
      _$MissionModelFromJson(json);
  Map<String, dynamic> toJson() => _$MissionModelToJson(this);

  double get progress => targetCount > 0 ? currentCount / targetCount : 0;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    rewardSparks,
    rewardOrbs,
    objectiveType,
    targetCount,
    currentCount,
    isComplete,
    isClaimed,
    availableUntil,
  ];
}

/// Event model
@JsonSerializable()
class EventModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? bannerUrl;
  final DateTime startDate;
  final DateTime endDate;
  final List<QuestModel> quests;
  final int bonusMultiplier;
  final bool isActive;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.bannerUrl,
    required this.startDate,
    required this.endDate,
    this.quests = const [],
    this.bonusMultiplier = 1,
    this.isActive = true,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  Duration get timeRemaining => endDate.difference(DateTime.now());

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    bannerUrl,
    startDate,
    endDate,
    quests,
    bonusMultiplier,
    isActive,
  ];
}
