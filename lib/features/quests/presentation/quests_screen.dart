import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/models/quest_model.dart';
import '../data/quest_repository.dart';

class QuestsScreen extends ConsumerStatefulWidget {
  const QuestsScreen({super.key});

  @override
  ConsumerState<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends ConsumerState<QuestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _calculateRequiredQuests(int level) {
    if (level < 1) return 3;
    return 3 * pow(2, (level - 1) ~/ 10).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final globalQuestsAsync = ref.watch(questsByTypeProvider(QuestType.global));
    final sectorQuestsAsync = ref.watch(questsByTypeProvider(QuestType.sector));
    final communityQuestsAsync = ref.watch(
      questsByTypeProvider(QuestType.community),
    );
    final userProgressAsync = ref.watch(userQuestProgressProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: profileAsync.when(
        data: (profile) {
          final level = profile?.level ?? 1;
          final requiredQuests = _calculateRequiredQuests(level);

          // Calculate completed global quests this week
          int completedThisWeek = 0;
          userProgressAsync.whenData((progress) {
            // Logic to filter would go here, simplified for display
            // We need to know which of these progress items are 'global' quests.
            // For now, we will just count all completed for demonstration or mock it.
            completedThisWeek = progress
                .where(
                  (p) =>
                      p.status == QuestStatus.completed &&
                      p.completedAt != null &&
                      p.completedAt!.isAfter(
                        DateTime.now().subtract(const Duration(days: 7)),
                      ),
                )
                .length;
          });

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Text(
                  'Quest Board',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete missions to earn Shards, Orbs, and XP.',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                // Weekly Progress Card
                _WeeklyProgressCard(
                  level: level,
                  current: completedThisWeek,
                  target: requiredQuests,
                ),
                const SizedBox(height: 32),

                // Tabs
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.royalPurple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.royalPurple),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: AppColors.royalPurple,
                    unselectedLabelColor: AppColors.textSecondaryDark,
                    labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Global Quests'),
                      Tab(text: 'Sector Quests'),
                      Tab(text: 'Community'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _QuestList(
                        questsAsync: globalQuestsAsync,
                        type: QuestType.global,
                      ),
                      _QuestList(
                        questsAsync: sectorQuestsAsync,
                        type: QuestType.sector,
                      ),
                      _QuestList(
                        questsAsync: communityQuestsAsync,
                        type: QuestType.community,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.cyanAccent),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error loading profile: $err',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  final int level;
  final int current;
  final int target;

  const _WeeklyProgressCard({
    required this.level,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E1C4E),
            Color(0xFF1A102E),
          ], // Deep purple gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.royalPurple.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.royalPurple,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Info Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.spark.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Level $level Requirement',
                        style: const TextStyle(
                          color: AppColors.spark,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete $target Global Quests this week',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$current / $target Completed',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestList extends StatelessWidget {
  final AsyncValue<List<QuestModel>> questsAsync;
  final QuestType type;

  const _QuestList({required this.questsAsync, required this.type});

  @override
  Widget build(BuildContext context) {
    return questsAsync.when(
      data: (quests) {
        if (quests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No active ${type.name} quests',
                  style: TextStyle(color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: quests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _QuestCard(quest: quests[index], type: type);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.royalPurple),
      ),
      error: (err, _) => Center(
        child: Text(
          'Failed to load quests: $err',
          style: const TextStyle(color: AppColors.error),
        ),
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final QuestModel quest;
  final QuestType type;

  const _QuestCard({required this.quest, required this.type});

  Color _getTypeColor() {
    switch (type) {
      case QuestType.global:
        return AppColors.royalPurple;
      case QuestType.sector:
        return AppColors.cyanAccent; // Or specific sector color
      case QuestType.mission:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // View Quest Details / Accept
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon / Type Indicator
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Icon(
                    type == QuestType.mission ? Icons.groups : Icons.public,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quest.title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quest.description,
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Rewards
                      Row(
                        children: [
                          _RewardBadge(
                            label: '${quest.rewardSparks} Shards',
                            icon: Icons.flash_on,
                            color: AppColors.spark,
                          ),
                          const SizedBox(width: 8),
                          _RewardBadge(
                            label: '${quest.rewardOrbs} Orbs',
                            icon: Icons.circle, // orb icon substitute
                            color: AppColors.orb,
                          ),
                          const SizedBox(width: 8),
                          _RewardBadge(
                            label: '${quest.xpReward} XP',
                            icon: Icons.star,
                            color: AppColors.cyanAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Button
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _RewardBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
