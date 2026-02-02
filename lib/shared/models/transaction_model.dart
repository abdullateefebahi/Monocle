import 'package:equatable/equatable.dart';

enum TransactionType {
  deposit,
  withdrawal,
  transfer,
  questReward,
  dailyBonus,
  purchase,
  unknown
}

enum TransactionStatus { pending, completed, failed, unknown }

class TransactionModel extends Equatable {
  final String id;
  final String userId;
  final TransactionType type;
  final int amount;
  final String currency; // 'sparks' or 'orbs'
  final TransactionStatus status;
  final String? description;
  final String? relatedUserId;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    this.description,
    this.relatedUserId,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: _parseType(json['type'] as String?),
      amount: json['amount'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'sparks',
      status: _parseStatus(json['status'] as String?),
      description: json['description'] as String?,
      relatedUserId: json['related_user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static TransactionType _parseType(String? type) {
    switch (type) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'transfer':
        return TransactionType.transfer;
      case 'quest_reward':
        return TransactionType.questReward;
      case 'daily_bonus':
        return TransactionType.dailyBonus;
      case 'purchase':
        return TransactionType.purchase;
      default:
        return TransactionType.unknown;
    }
  }

  static TransactionStatus _parseStatus(String? status) {
    switch (status) {
      case 'pending':
        return TransactionStatus.pending;
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.unknown;
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        amount,
        currency,
        status,
        description,
        relatedUserId,
        createdAt,
      ];
}
