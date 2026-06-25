import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../notification_service.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_bloc/chat_event.dart';
import '../bloc/chat_bloc/chat_state.dart';
import '../widgets/app_chat_tile.dart';
import '../widgets/search_delgate.dart';
import 'all_chats_page.dart';
import 'chat_room_page.dart';
import 'create_group_page.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(WatchRoomsStarted());
    _setupNotifications();
  }

  void _refreshChats() {
    context.read<ChatBloc>().add(WatchRoomsStarted());
  }

  Future<void> _setupNotifications() async {
    await NotificationService.requestPermission();
    await NotificationService.saveTokenToSupabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllChatsPage()),
          ).then((_) => _refreshChats());
        },
        child: const Icon(Icons.person_add),
      ),
      appBar: AppBar(
        title: const Text('المحادثات'),
        actions: [
          // أيقونة إنشاء مجموعة جديدة مضافة هنا بشكل أنيق
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateGroupPage()),
              ).then((_) => _refreshChats());
            },
            icon: const Icon(Icons.group_add),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomDelegate(chatBloc: context.read<ChatBloc>()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              final user = Supabase.instance.client.auth.currentUser;

              if (user != null) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (innerContext) => BlocProvider.value(
                      value: context.read<ChatBloc>(),
                      child: ProfileScreen(currentUserId: user.id),
                    ),
                  ),
                );

                if (mounted) _refreshChats();
              }
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
        current is RoomsLoaded ||
            current is ChatLoading ||
            current is ChatError,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RoomsLoaded) {
            if (state.rooms.isEmpty) {
              return const Center(
                child: Text(
                  "لا توجد محادثات نشطة\nاضغط على الزر لبدء محادثة جديدة",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _refreshChats(),
              child: ListView.separated(
                itemCount: state.rooms.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final chat = state.rooms[index];

                  return AppChatTile(
                    title: chat.name,
                    subTitle: chat.lastMessage.isEmpty
                        ? "لا توجد رسائل"
                        : chat.lastMessage,
                    imageUrl: chat.imageUrl,
                    isOnline: chat.isOnline,
                    unreadCount: chat.unreadCount,
                    time: _formatDateTime(chat.lastMessageTime),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatRoomScreen(chatEntity: chat, roomId: chat.id),
                        ),
                      );
                      if (mounted) _refreshChats();
                    },
                  );
                },
              ),
            );
          }
          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("خطأ: ${state.message}"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refreshChats,
                    child: const Text("إعادة المحاولة"),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("جاري جلب المحادثات..."));
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.day == now.day) {
      return DateFormat('hh:mm a').format(dateTime);
    }
    return DateFormat('dd/MM').format(dateTime);
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (childContext) => AlertDialog(
      title: const Text('تسجيل الخروج'),
      content: const Text('هل أنت متأكد أنك تريد مغادرة التطبيق؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(childContext),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();

            if (context.mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          },
          child: const Text('خروج', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}