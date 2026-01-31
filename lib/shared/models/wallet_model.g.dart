// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
  userId: json['userId'] as String,
  shardBalance: (json['shardBalance'] as num?)?.toInt() ?? 0,
  orbBalance: (json['orbBalance'] as num?)?.toInt() ?? 0,
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'shardBalance': instance.shardBalance,
      'orbBalance': instance.orbBalance,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      currency: $enumDecode(_$CurrencyTypeEnumMap, json['currency']),
      amount: (json['amount'] as num).toInt(),
      balanceAfter: (json['balanceAfter'] as num).toInt(),
      description: json['description'] as String?,
      referenceId: json['referenceId'] as String?,
      referenceType: json['referenceType'] as String?,
      fromUserId: json['fromUserId'] as String?,
      toUserId: json['toUserId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'currency': _$CurrencyTypeEnumMap[instance.currency]!,
      'amount': instance.amount,
      'balanceAfter': instance.balanceAfter,
      'description': instance.description,
      'referenceId': instance.referenceId,
      'referenceType': instance.referenceType,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.credit: 'credit',
  TransactionType.debit: 'debit',
  TransactionType.transfer: 'transfer',
  TransactionType.reward: 'reward',
  TransactionType.purchase: 'purchase',
  TransactionType.refund: 'refund',
};

const _$CurrencyTypeEnumMap = {
  CurrencyType.spark: 'spark',
  CurrencyType.orb: 'orb',
};

TransferRequest _$TransferRequestFromJson(Map<String, dynamic> json) =>
    TransferRequest(
      toUserId: json['toUserId'] as String,
      currency: $enumDecode(_$CurrencyTypeEnumMap, json['currency']),
      amount: (json['amount'] as num).toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TransferRequestToJson(TransferRequest instance) =>
    <String, dynamic>{
      'toUserId': instance.toUserId,
      'currency': _$CurrencyTypeEnumMap[instance.currency]!,
      'amount': instance.amount,
      'note': instance.note,
    };
