import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../shared/models/quest_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';

class QuestRepository {
  final SupabaseClient _supabase;

  QuestRepository(this._supabase);

  // Fetch quests by type
  Future<List<QuestModel>> fetchQuests({
    QuestType? type,
    String? communityId,
  }) async {
    var query = _supabase.from('quests').select().eq('is_active', true);

    if (type != null) {
      // Convert enum to string value (e.g. 'global')
      // Assuming enum name matches DB value string
      query = query.eq('type', type.name);
    }

    if (communityId != null) {
      query = query.eq('community_id', communityId);
    } else if (type == QuestType.global) {
      // Fetch global quests using the designated Global Community ID
      query = query.eq('community_id', AppConstants.globalCommunityId);
    }

    final response = await query.order('created_at', ascending: false);

    // Debug: Parse each quest individually to identify which field causes issues
    final List<QuestModel> quests = [];
    for (final json in (response as List)) {
      try {
        quests.add(QuestModel.fromJson(json as Map<String, dynamic>));
      } catch (e) {
        // Skip malformed quest data, continue loading others
        debugPrint('Error parsing quest: $e');
        continue;
      }
    }
    return quests;
  }

  // Fetch user's active/completed progress
  Future<List<UserQuestProgress>> fetchUserProgress(String userId) async {
    final response = await _supabase
        .from('user_quest_progress')
        .select(
          '*, quests(*)',
        ) // Join with quest details if needed, or just ids
        .eq('user_id', userId);

    // Note: The UserQuestProgress model expects 'objectives' which might need join or json parsing
    return (response as List)
        .map((json) => UserQuestProgress.fromJson(json))
        .toList();
  }

  // Start a quest
  Future<void> startQuest(String userId, String questId) async {
    // Check if already started
    final existing = await _supabase
        .from('user_quest_progress')
        .select()
        .eq('user_id', userId)
        .eq('quest_id', questId)
        .eq('status', 'active')
        .maybeSingle();

    if (existing != null) return;

    // Get quest default objectives to initialize progress
    final questRes = await _supabase
        .from('quests')
        .select()
        .eq('id', questId)
        .single();
    final quest = QuestModel.fromJson(questRes);

    await _supabase.from('user_quest_progress').insert({
      'user_id': userId,
      'quest_id': questId,
      'status': 'active',
      'objectives': quest.objectives.map((e) => e.toJson()).toList(),
      'started_at': DateTime.now().toIso8601String(),
    });
  }
}

// Providers
final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return QuestRepository(SupabaseService.client);
});

final questsByTypeProvider = FutureProvider.family<List<QuestModel>, QuestType>(
  (ref, type) async {
    final repo = ref.watch(questRepositoryProvider);
    return repo.fetchQuests(type: type);
  },
);

final userQuestProgressProvider =
    FutureProvider.autoDispose<List<UserQuestProgress>>((ref) async {
      final user = ref.watch(currentUserProvider);
      if (user == null) return [];
      final repo = ref.watch(questRepositoryProvider);
      return repo.fetchUserProgress(user.id);
    });
