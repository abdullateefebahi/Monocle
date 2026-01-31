import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'community_model.g.dart';

/// Community model for "Limitless Communities"
@JsonSerializable()
class CommunityModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final String? bannerUrl;
  final String ownerId;
  final String sectorType; // e.g., 'tech', 'art', 'gaming', 'business'
  final bool isPublic;
  final bool isVerified;
  final int memberCount;
  final int maxMembers;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final CommunitySettings settings;
  final List<String> tags;

  const CommunityModel({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.bannerUrl,
    required this.ownerId,
    required this.sectorType,
    this.isPublic = true,
    this.isVerified = false,
    this.memberCount = 0,
    this.maxMembers = 10000,
    required this.createdAt,
    this.updatedAt,
    this.settings = const CommunitySettings(),
    this.tags = const [],
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    String? bannerUrl,
    String? ownerId,
    String? sectorType,
    bool? isPublic,
    bool? isVerified,
    int? memberCount,
    int? maxMembers,
    DateTime? createdAt,
    DateTime? updatedAt,
    CommunitySettings? settings,
    List<String>? tags,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      ownerId: ownerId ?? this.ownerId,
      sectorType: sectorType ?? this.sectorType,
      isPublic: isPublic ?? this.isPublic,
      isVerified: isVerified ?? this.isVerified,
      memberCount: memberCount ?? this.memberCount,
      maxMembers: maxMembers ?? this.maxMembers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    iconUrl,
    bannerUrl,
    ownerId,
    sectorType,
    isPublic,
    isVerified,
    memberCount,
    maxMembers,
    createdAt,
    updatedAt,
    settings,
    tags,
  ];
}

/// Community settings
@JsonSerializable()
class CommunitySettings extends Equatable {
  final bool allowInvites;
  final bool requireApproval;
  final bool allowMemberPosts;
  final int entryFeeSparks;
  final int entryFeeOrbs;

  const CommunitySettings({
    this.allowInvites = true,
    this.requireApproval = false,
    this.allowMemberPosts = true,
    this.entryFeeSparks = 0,
    this.entryFeeOrbs = 0,
  });

  factory CommunitySettings.fromJson(Map<String, dynamic> json) =>
      _$CommunitySettingsFromJson(json);
  Map<String, dynamic> toJson() => _$CommunitySettingsToJson(this);

  @override
  List<Object?> get props => [
    allowInvites,
    requireApproval,
    allowMemberPosts,
    entryFeeSparks,
    entryFeeOrbs,
  ];
}

/// Community member role
enum CommunityRole {
  @JsonValue('owner')
  owner,
  @JsonValue('admin')
  admin,
  @JsonValue('moderator')
  moderator,
  @JsonValue('member')
  member,
}

/// Community membership model
@JsonSerializable()
class CommunityMemberModel extends Equatable {
  final String id;
  final String communityId;
  final String userId;
  final CommunityRole role;
  final DateTime joinedAt;
  final bool isActive;
  final Map<String, dynamic>? customRoleData;

  const CommunityMemberModel({
    required this.id,
    required this.communityId,
    required this.userId,
    this.role = CommunityRole.member,
    required this.joinedAt,
    this.isActive = true,
    this.customRoleData,
  });

  factory CommunityMemberModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityMemberModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    communityId,
    userId,
    role,
    joinedAt,
    isActive,
    customRoleData,
  ];
}

/// Channel model for community communication
@JsonSerializable()
class ChannelModel extends Equatable {
  final String id;
  final String communityId;
  final String name;
  final String? description;
  final ChannelType type;
  final bool isDefault;
  final int position;
  final DateTime createdAt;

  const ChannelModel({
    required this.id,
    required this.communityId,
    required this.name,
    this.description,
    this.type = ChannelType.text,
    this.isDefault = false,
    this.position = 0,
    required this.createdAt,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    communityId,
    name,
    description,
    type,
    isDefault,
    position,
    createdAt,
  ];
}

enum ChannelType {
  @JsonValue('text')
  text,
  @JsonValue('announcement')
  announcement,
  @JsonValue('voice')
  voice,
}
