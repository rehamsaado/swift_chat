import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../domain/entities/chat_entity.dart';
import '../bloc/message_bloc/message_bloc.dart';
import '../bloc/message_bloc/message_event.dart';
import '../bloc/message_bloc/message_state.dart';
import '../widgets/chat_bubble_widget.dart';
import '../widgets/message_input_bar_widget.dart';
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
  Map<String, Map<String, dynamic>> _roomMembersProfiles = {};

  @override
  void initState() {
    super.initState();
    _messageBloc = sl<MessageBloc>();
    _messageBloc.add(WatchMessagesStarted(widget.roomId));
    if (widget.chatEntity.isGroup) {
      _loadRoomMembersProfiles();
    }
  }

  Future<void> _loadRoomMembersProfiles() async {
    try {
      final data = await Supabase.instance.client
          .from('room_members')
          .select('user_id, profiles(full_name, avatar_url)')
          .eq('room_id', widget.roomId);

      final Map<String, Map<String, dynamic>> membersMap = {};
      for (var item in data) {
        final userId = item['user_id']?.toString();
        final profile = item['profiles'] as Map<String, dynamic>?;
        if (userId != null && profile != null) {
          membersMap[userId] = {
            'full_name': profile['full_name'] ?? 'مستخدم غير معروف',
            'avatar_url': profile['avatar_url'] ?? '',
          };
        }
      }
      if (mounted) {
        setState(() {
          _roomMembersProfiles = membersMap;
        });
      }
    } catch (_) {}
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
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MessageError &&
                      (context.read<MessageBloc>().state is! MessageLoaded)) {
                    return Center(child: Text("خطأ: ${state.message}"));
                  }

                  if (state is MessageLoaded) {
                    if (state.messages.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final bool isMe = msg.senderId == _myId;
                        final isGroup = widget.chatEntity.isGroup;
                        final senderProfile = _roomMembersProfiles[msg.senderId];
                        final String senderName = senderProfile?['full_name'] ?? 'مستخدم غير معروف';
                        final String? senderImageUrl = senderProfile?['avatar_url'];

                        return ChatBubble(
                          key: ValueKey(msg.id),
                          message: msg.content,
                          isMe: isMe,
                          time: msg.createdAt,
                          type: msg.type,
                          status: msg.status,
                          isGroup: isGroup,
                          senderName: senderName,
                          senderImageUrl: senderImageUrl,
                        );
                      },
                    );
                  }

                  if (state is MessageError) {
                    return Center(
                      child: Text(
                        "خطأ: ${state.message}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
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
    final isGroup = widget.chatEntity.isGroup;

    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: () {
          if (isGroup) {
            _showGroupDetailsBottomSheet(context);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  currentUserId: widget.chatEntity.id,
                  isReadOnly: true,
                ),
              ),
            );
          }
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.chatEntity.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isGroup ? "اضغط هنا لعرض الأعضاء والمدير" : "غير متصل",
                    style: TextStyle(
                      fontSize: 11,
                      color: isGroup ? Colors.blue[600] : Colors.grey[600],
                      fontWeight: isGroup ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (isGroup)
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showGroupDetailsBottomSheet(context),
          )
        else ...[
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        ],
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

  void _showGroupDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final myId = Supabase.instance.client.auth.currentUser?.id;
        final isAdmin = widget.chatEntity.createdBy == myId;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'تفاصيل مجموعة: ${widget.chatEntity.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'الأعضاء والمسؤولين:',
                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey[100],
                        child: const Icon(Icons.person, color: Colors.blueGrey),
                      ),
                      title: Text(isAdmin ? 'أنت (منشئ المجموعة)' : 'مدير المجموعة'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'المدير',
                          style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Divider(),
                    FutureBuilder<List<dynamic>>(
                      future: Supabase.instance.client
                          .from('room_members')
                          .select('profiles(full_name)')
                          .eq('room_id', widget.roomId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("فشل في تحميل الأعضاء", style: TextStyle(color: Colors.red, fontSize: 12)),
                          );
                        }

                        final data = snapshot.data!;
                        List<String> names = [];
                        for (var item in data) {
                          if (item['profiles'] != null && item['profiles']['full_name'] != null) {
                            names.add(item['profiles']['full_name'].toString());
                          }
                        }

                        if (names.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("لا يوجد أعضاء آخرين", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          );
                        }

                        return Column(
                          children: names.map((memberName) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: Text(memberName.isNotEmpty ? memberName[0].toUpperCase() : "?"),
                              ),
                              title: Text(memberName),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}