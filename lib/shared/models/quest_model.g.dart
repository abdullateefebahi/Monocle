// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestModel _$QuestModelFromJson(Map<String, dynamic> json) => QuestModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$QuestTypeEnumMap, json['type']),
  iconUrl: json['icon_url'] as String?,
  rarity:
      $enumDecodeNullable(_$QuestRarityEnumMap, json['rarity']) ??
      QuestRarity.common,
  rewardSparks: (json['reward_sparks'] as num?)?.toInt() ?? 0,
  rewardOrbs: (json['reward_orbs'] as num?)?.toInt() ?? 0,
  xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
  objectives:
      (json['objectives'] as List<dynamic>?)
          ?.map((e) => QuestObjective.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  maxCompletions: (json['max_completions'] as num?)?.toInt(),
  currentCompletions: (json['current_completions'] as num?)?.toInt() ?? 0,
  isRepeatable: json['is_repeatable'] as bool? ?? false,
  communityId: json['community_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$QuestModelToJson(QuestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'rarity': _$QuestRarityEnumMap[instance.rarity]!,
      'type': _$QuestTypeEnumMap[instance.type]!,
      'reward_sparks': instance.rewardSparks,
      'reward_orbs': instance.rewardOrbs,
      'xp_reward': instance.xpReward,
      'objectives': instance.objectives,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'max_completions': instance.maxCompletions,
      'current_completions': instance.currentCompletions,
      'is_repeatable': instance.isRepeatable,
      'community_id': instance.communityId,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$QuestTypeEnumMap = {
  QuestType.daily: 'daily',
  QuestType.weekly: 'weekly',
  QuestType.story: 'story',
  QuestType.event: 'event',
  QuestType.community: 'community',
  QuestType.global: 'global',
  QuestType.sector: 'sector',
  QuestType.mission: 'mission',
};

const _$QuestRarityEnumMap = {
  QuestRarity.common: 'common',
  QuestRarity.uncommon: 'uncommon',
  QuestRarity.rare: 'rare',
  QuestRarity.epic: 'epic',
  QuestRarity.legendary: 'legendary',
};

QuestObjective _$QuestObjectiveFromJson(Map<String, dynamic> json) =>
    QuestObjective(
      id: json['id'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$ObjectiveTypeEnumMap, json['type']),
      targetCount: (json['target_count'] as num?)?.toInt() ?? 1,
      currentCount: (json['current_count'] as num?)?.toInt() ?? 0,
      requirements: json['requirements'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$QuestObjectiveToJson(QuestObjective instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'type': _$ObjectiveTypeEnumMap[instance.type]!,
      'target_count': instance.targetCount,
      'current_count': instance.currentCount,
      'requirements': instance.requirements,
    };

const _$ObjectiveTypeEnumMap = {
  ObjectiveType.sendMessage: 'send_message',
  ObjectiveType.joinCommunity: 'join_community',
  ObjectiveType.completeProfile: 'complete_profile',
  ObjectiveType.makeTransfer: 'make_transfer',
  ObjectiveType.inviteUser: 'invite_user',
  ObjectiveType.earnShards: 'earn_shards',
  ObjectiveType.spendShards: 'spend_shards',
  ObjectiveType.loginStreak: 'login_streak',
  ObjectiveType.custom: 'custom',
};

UserQuestProgress _$UserQuestProgressFromJson(Map<String, dynamic> json) =>
    UserQuestProgress(
      id: json['id'] as String,
      questId: json['questId'] as String,
      userId: json['userId'] as String,
      status:
          $enumDecodeNullable(_$QuestStatusEnumMap, json['status']) ??
          QuestStatus.active,
      objectives: (json['objectives'] as List<dynamic>)
          .map((e) => QuestObjective.fromJson(e as Map<String, dynamic>))
          .toList(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      claimedAt: json['claimedAt'] == null
          ? null
          : DateTime.parse(json['claimedAt'] as String),
    );

Map<String, dynamic> _$UserQuestProgressToJson(UserQuestProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questId': instance.questId,
      'userId': instance.userId,
      'status': _$QuestStatusEnumMap[instance.status]!,
      'objectives': instance.objectives,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'claimedAt': instance.claimedAt?.toIso8601String(),
    };

const _$QuestStatusEnumMap = {
  QuestStatus.available: 'available',
  QuestStatus.active: 'active',
  QuestStatus.completed: 'completed',
  QuestStatus.claimed: 'claimed',
  QuestStatus.expired: 'expired',
};

MissionModel _$MissionModelFromJson(Map<String, dynamic> json) => MissionModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  rewardSparks: (json['rewardSparks'] as num?)?.toInt() ?? 0,
  rewardOrbs: (json['rewardOrbs'] as num?)?.toInt() ?? 0,
  objectiveType: $enumDecode(_$ObjectiveTypeEnumMap, json['objectiveType']),
  targetCount: (json['targetCount'] as num).toInt(),
  currentCount: (json['currentCount'] as num?)?.toInt() ?? 0,
  isComplete: json['isComplete'] as bool? ?? false,
  isClaimed: json['isClaimed'] as bool? ?? false,
  availableUntil: DateTime.parse(json['availableUntil'] as String),
);

Map<String, dynamic> _$MissionModelToJson(MissionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'rewardSparks': instance.rewardSparks,
      'rewardOrbs': instance.rewardOrbs,
      'objectiveType': _$ObjectiveTypeEnumMap[instance.objectiveType]!,
      'targetCount': instance.targetCount,
      'currentCount': instance.currentCount,
      'isComplete': instance.isComplete,
      'isClaimed': instance.isClaimed,
      'availableUntil': instance.availableUntil.toIso8601String(),
    };

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  bannerUrl: json['bannerUrl'] as String?,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  quests:
      (json['quests'] as List<dynamic>?)
          ?.map((e) => QuestModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  bonusMultiplier: (json['bonusMultiplier'] as num?)?.toInt() ?? 1,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'bannerUrl': instance.bannerUrl,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'quests': instance.quests,
      'bonusMultiplier': instance.bonusMultiplier,
      'isActive': instance.isActive,
    };
