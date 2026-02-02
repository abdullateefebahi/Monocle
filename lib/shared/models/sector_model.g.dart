// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sector_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectorModel _$SectorModelFromJson(Map<String, dynamic> json) => SectorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconName: json['icon_name'] as String?,
      colorHex: json['color_hex'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      communityCount: (json['community_count'] as num?)?.toInt(),
      totalMembers: (json['total_members'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SectorModelToJson(SectorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'community_count': instance.communityCount,
      'total_members': instance.totalMembers,
    };
