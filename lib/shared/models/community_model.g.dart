// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      ownerId: json['ownerId'] as String,
      sectorType: json['sectorType'] as String,
      isPublic: json['isPublic'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      maxMembers: (json['maxMembers'] as num?)?.toInt() ?? 10000,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      settings: json['settings'] == null
          ? const CommunitySettings()
          : CommunitySettings.fromJson(
              json['settings'] as Map<String, dynamic>,
            ),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'bannerUrl': instance.bannerUrl,
      'ownerId': instance.ownerId,
      'sectorType': instance.sectorType,
      'isPublic': instance.isPublic,
      'isVerified': instance.isVerified,
      'memberCount': instance.memberCount,
      'maxMembers': instance.maxMembers,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'settings': instance.settings,
      'tags': instance.tags,
    };

CommunitySettings _$CommunitySettingsFromJson(Map<String, dynamic> json) =>
    CommunitySettings(
      allowInvites: json['allowInvites'] as bool? ?? true,
      requireApproval: json['requireApproval'] as bool? ?? false,
      allowMemberPosts: json['allowMemberPosts'] as bool? ?? true,
      entryFeeSparks: (json['entryFeeSparks'] as num?)?.toInt() ?? 0,
      entryFeeOrbs: (json['entryFeeOrbs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CommunitySettingsToJson(CommunitySettings instance) =>
    <String, dynamic>{
      'allowInvites': instance.allowInvites,
      'requireApproval': instance.requireApproval,
      'allowMemberPosts': instance.allowMemberPosts,
      'entryFeeSparks': instance.entryFeeSparks,
      'entryFeeOrbs': instance.entryFeeOrbs,
    };

CommunityMemberModel _$CommunityMemberModelFromJson(
  Map<String, dynamic> json,
) => CommunityMemberModel(
  id: json['id'] as String,
  communityId: json['communityId'] as String,
  userId: json['userId'] as String,
  role:
      $enumDecodeNullable(_$CommunityRoleEnumMap, json['role']) ??
      CommunityRole.member,
  joinedAt: DateTime.parse(json['joinedAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
  customRoleData: json['customRoleData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CommunityMemberModelToJson(
  CommunityMemberModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'communityId': instance.communityId,
  'userId': instance.userId,
  'role': _$CommunityRoleEnumMap[instance.role]!,
  'joinedAt': instance.joinedAt.toIso8601String(),
  'isActive': instance.isActive,
  'customRoleData': instance.customRoleData,
};

const _$CommunityRoleEnumMap = {
  CommunityRole.owner: 'owner',
  CommunityRole.admin: 'admin',
  CommunityRole.moderator: 'moderator',
  CommunityRole.member: 'member',
};

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
  id: json['id'] as String,
  communityId: json['communityId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  type:
      $enumDecodeNullable(_$ChannelTypeEnumMap, json['type']) ??
      ChannelType.text,
  isDefault: json['isDefault'] as bool? ?? false,
  position: (json['position'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'communityId': instance.communityId,
      'name': instance.name,
      'description': instance.description,
      'type': _$ChannelTypeEnumMap[instance.type]!,
      'isDefault': instance.isDefault,
      'position': instance.position,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ChannelTypeEnumMap = {
  ChannelType.text: 'text',
  ChannelType.announcement: 'announcement',
  ChannelType.voice: 'voice',
};
