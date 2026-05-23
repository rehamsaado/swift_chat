import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../domain/entities/chat_entity.dart';
import '../bloc/message_bloc/message_bloc.dart';
import '../bloc/message_bloc/message_event.dart';
import '../bloc/message_bloc/message_state.dart';
import '../widgets/chat_bubble_widget.dart';
import '../widgets/meesage_input_bar_widget.dart';
import '../../../../core/injection_container.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatEntity chatEntity;
  final String roomId;

  const ChatRoomScreen({
    super.key,
    required this.chatEntity,
    required this.roomId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late MessageBloc _messageBloc;
  final String? _myId = Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _messageBloc = sl<MessageBloc>();
    _messageBloc.add(WatchMessagesStarted(widget.roomId));

  }

  @override
  void dispose() {
    _messageBloc.add(MarkMessagesAsRead(widget.roomId));
    _messageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _messageBloc,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // منطقة عرض الرسائل (Stream)
            // استبدلي الجزء الخاص بالـ BlocBuilder بهذا الكود المحدث:
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                // حذفنا الـ buildWhen تماماً لضمان التحديث اللحظي
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MessageError && (context.read<MessageBloc>().state is! MessageLoaded)) {
                    return Center(child: Text("خطأ: ${state.message}"));
                  }

                  if (state is MessageLoaded) {
                    if (state.messages.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      // حذفنا الـ key عشان ما "يعلق" الـ scroll
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final bool isMe = msg.senderId == _myId;

                        return ChatBubble(
                          key: ValueKey(msg.id), // هذا الـ key للرسالة الواحدة ممتاز خليه
                          message: msg.content,
                          isMe: isMe,
                          time: msg.createdAt,
                          type: msg.type,
                          status: msg.status,
                        );
                      },
                    );
                  }

                  if (state is MessageError) {
                    return Center(child: Text("خطأ: ${state.message}", style: const TextStyle(color: Colors.red)));
                  }

                  return const Center(child: Text("ابدأ المحادثة الآن..."));
                },
              ),
            ),
            MessageInputBar(roomId: widget.roomId),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                currentUserId: widget.chatEntity.peerId,
                isReadOnly: true,
              ),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: widget.chatEntity.imageUrl.isNotEmpty
                  ? NetworkImage(widget.chatEntity.imageUrl)
                  : null,
              child: widget.chatEntity.imageUrl.isEmpty
                  ? Text(widget.chatEntity.name[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.chatEntity.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // رجعنا الحالة لـ Text بسيط أو ممكن تحذفيه بالكامل
                Text(
                  "غير متصل",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("لا توجد رسائل بعد. قل مرحباً لـ ${widget.chatEntity.name}!"),
        ],
      ),
    );
  }
}
