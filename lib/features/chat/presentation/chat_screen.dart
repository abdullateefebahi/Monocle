import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/models/message_model.dart';
import '../data/chat_repository.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String communityId;
  final String communityName;

  const ChatScreen({
    super.key,
    required this.communityId,
    required this.communityName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatStreamProvider(widget.communityId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(widget.communityName,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet. Say hi!',
                      style: TextStyle(color: AppColors.textSecondaryDark),
                    ),
                  );
                }

                // Messages are usually reversed in list view for chat
                // But stream usually gives them in order. Let's reverse for UI if needed
                // Supabase stream returns full list every time.
                // Let's assume list is oldest to newest (ascending)
                final reversedMessages = messages.reversed.toList();

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final msg = reversedMessages[index];
                    final isMe = msg.senderId == currentUser?.id;
                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
              loading: () => const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.cyanAccent)),
              error: (err, stack) => Center(
                  child: Text('Error: $err',
                      style: TextStyle(color: AppColors.error))),
            ),
          ),
          _buildInputArea(currentUser?.id),
        ],
      ),
    );
  }

  Widget _buildInputArea(String? userId) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      userId == null ? 'Login to chat' : 'Type a message...',
                  hintStyle: TextStyle(color: AppColors.textSecondaryDark),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundDark,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                enabled: userId != null,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: userId == null ? null : _sendMessage,
              icon: const Icon(Icons.send),
              color: AppColors.cyanAccent,
              disabledColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      await ref.read(chatRepositoryProvider).sendMessage(
            communityId: widget.communityId,
            senderId: user.id,
            content: text,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to send: $e'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  Widget _buildMessageBubble(MessageModel msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.cyanAccent : AppColors.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? Radius.zero : null,
            bottomLeft: isMe ? null : Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.content,
              style: TextStyle(
                color: isMe ? AppColors.backgroundDark : Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
