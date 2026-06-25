import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_bloc/chat_event.dart';
import '../bloc/chat_bloc/chat_state.dart';
import 'chat_room_page.dart';


class AllChatsPage extends StatefulWidget {
  const AllChatsPage({super.key});

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  @override
  void initState() {
    super.initState();

    context.read<ChatBloc>().add(GetAllUsersStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بدء محادثة جديدة"),
        centerTitle: true,
      ),
      body: BlocBuilder<ChatBloc, ChatState>(

        buildWhen: (previous, current) =>
        current is ChatLoading || current is UsersLoaded || current is ChatError,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text("لا يوجد مستخدمين حالياً"));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: state.users.length,
              separatorBuilder: (context, index) => const Divider(indent: 70),
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(user.imageUrl),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user.bio ?? "لا يوجد وصف",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    // 1. جيبي الـ ID الحقيقي من البلوك
                    final String realRoomId = await context.read<ChatBloc>().getRoomId(user.id);

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomScreen(
                            chatEntity: user,
                            roomId: realRoomId,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }

          if (state is ChatError) {
            return Center(child: Text("خطأ: ${state.message}"));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}