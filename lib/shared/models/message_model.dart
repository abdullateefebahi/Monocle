import 'package:equatable/equatable.dart';

enum MessageType { text, image, system, unknown }

class MessageModel extends Equatable {
  final String id;
  final String communityId;
  final String senderId;
  final String content;
  final MessageType type;
  final String? replyToId;
  final bool isEdited;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.communityId,
    required this.senderId,
    required this.content,
    required this.type,
    this.replyToId,
    required this.isEdited,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      communityId: json['community_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      type: _parseType(json['type'] as String?),
      replyToId: json['reply_to_id'] as String?,
      isEdited: json['is_edited'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static MessageType _parseType(String? type) {
    switch (type) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.unknown;
    }
  }

  @override
  List<Object?> get props => [
        id,
        communityId,
        senderId,
        content,
        type,
        replyToId,
        isEdited,
        createdAt,
      ];
}
