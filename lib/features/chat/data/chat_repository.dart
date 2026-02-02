import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../shared/models/message_model.dart';

class ChatRepository {
  final SupabaseClient _supabase;

  ChatRepository(this._supabase);

  // Fetch recent messages
  Future<List<MessageModel>> fetchMessages(String communityId,
      {int limit = 50}) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('community_id', communityId)
          .order('created_at', ascending: false) // reversed for chat UI
          .limit(limit);

      return (response as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  // Subscribe to new messages (Real-time)
  Stream<List<MessageModel>> streamMessages(String communityId) {
    final stream = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('community_id', communityId)
        .order('created_at')
        .map(
            (data) => data.map((json) => MessageModel.fromJson(json)).toList());

    return stream;
  }

  // Send a message
  Future<void> sendMessage({
    required String communityId,
    required String content,
    required String senderId,
    MessageType type = MessageType.text,
  }) async {
    await _supabase.from('messages').insert({
      'community_id': communityId,
      'sender_id': senderId,
      'content': content,
      'type': type.name,
    });
  }
}

// Providers
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(SupabaseService.client);
});

final chatStreamProvider = StreamProvider.family
    .autoDispose<List<MessageModel>, String>((ref, communityId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.streamMessages(communityId);
});
