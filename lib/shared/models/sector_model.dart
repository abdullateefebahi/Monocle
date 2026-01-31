import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sector_model.g.dart';

/// Sector model for organizing communities
@JsonSerializable()
class SectorModel extends Equatable {
  final String id;
  final String name;
  final String? description;

  @JsonKey(name: 'icon_name')
  final String? iconName; // Material icon name

  @JsonKey(name: 'color_hex')
  final String? colorHex; // Hex color code

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'display_order')
  final int displayOrder;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Stats (from join or aggregation)
  @JsonKey(name: 'community_count')
  final int? communityCount;

  @JsonKey(name: 'total_members')
  final int? totalMembers;

  const SectorModel({
    required this.id,
    required this.name,
    this.description,
    this.iconName,
    this.colorHex,
    this.isActive = true,
    this.displayOrder = 0,
    required this.createdAt,
    this.updatedAt,
    this.communityCount,
    this.totalMembers,
  });

  factory SectorModel.fromJson(Map<String, dynamic> json) =>
      _$SectorModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectorModelToJson(this);

  SectorModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? colorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? communityCount,
    int? totalMembers,
  }) {
    return SectorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      communityCount: communityCount ?? this.communityCount,
      totalMembers: totalMembers ?? this.totalMembers,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    iconName,
    colorHex,
    isActive,
    displayOrder,
    createdAt,
    updatedAt,
    communityCount,
    totalMembers,
  ];
}
