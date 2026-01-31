import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final String id;
  final String userId;
  final int sparkBalance;
  final int orbBalance;
  final int lifetimeSparksEarned;
  final int lifetimeOrbsEarned;
  final DateTime? lastDailyBonusAt;

  const WalletModel({
    required this.id,
    required this.userId,
    required this.sparkBalance,
    required this.orbBalance,
    required this.lifetimeSparksEarned,
    required this.lifetimeOrbsEarned,
    this.lastDailyBonusAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      sparkBalance: json['spark_balance'] as int? ?? 0,
      orbBalance: json['orb_balance'] as int? ?? 0,
      lifetimeSparksEarned: json['lifetime_sparks_earned'] as int? ?? 0,
      lifetimeOrbsEarned: json['lifetime_orbs_earned'] as int? ?? 0,
      lastDailyBonusAt: json['last_daily_bonus_at'] != null
          ? DateTime.parse(json['last_daily_bonus_at'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    sparkBalance,
    orbBalance,
    lifetimeSparksEarned,
    lifetimeOrbsEarned,
    lastDailyBonusAt,
  ];
}
