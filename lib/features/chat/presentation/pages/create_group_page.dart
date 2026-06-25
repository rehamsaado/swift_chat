import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_entity.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_bloc/chat_event.dart';
import '../bloc/chat_bloc/chat_state.dart';
import 'chat_room_page.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _selectedUserIds = [];
  final String _groupImageUrl = '';

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetAllUsersStarted());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitGroup() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال اسم المجموعة')),
      );
      return;
    }
    if (_selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار عضو واحد على الأقل')),
      );
      return;
    }

    context.read<ChatBloc>().add(
      CreateGroupStarted(
        name: _nameController.text.trim(),
        imageUrl: _groupImageUrl.isEmpty
            ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_nameController.text)}&background=random'
            : _groupImageUrl,
        memberIds: _selectedUserIds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مجموعة جديدة'),
        actions: [
          IconButton(onPressed: _submitGroup, icon: const Icon(Icons.check)),
        ],
      ),
      body: BlocListener<ChatBloc, ChatState>(
        // نستمع هنا فقط لحالات نجاح وفشل إنشاء الغروب لمنع تداخل اللودينغ
        listenWhen: (previous, current) =>
        current is GroupCreatedSuccessfully || current is ChatError,
        listener: (context, state) {
          if (state is GroupCreatedSuccessfully) {
            // إغلاق الديالوج في حال كان مفتوحاً
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ChatRoomScreen(
                  roomId: state.roomId,
                  chatEntity: ChatEntity(
                    id: state.roomId,
                    name: _nameController.text.trim(),
                    imageUrl: _groupImageUrl.isEmpty
                        ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_nameController.text)}&background=random'
                        : _groupImageUrl,
                    lastMessage: '',
                    lastMessageTime: DateTime.now(),
                    unreadCount: 0,
                    lastSenderId: '',
                    isGroup: true,
                  ),
                ),
              ),
            );
          } else if (state is ChatError) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'اسم المجموعة...',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) =>
                current is UsersLoaded || current is ChatLoading || current is ChatError,
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is UsersLoaded) {
                    if (state.users.isEmpty) {
                      return const Center(
                        child: Text('لا يوجد مستخدمين متاحين'),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        final isSelected = _selectedUserIds.contains(user.id);

                        return CheckboxListTile(
                          title: Text(user.name),
                          secondary: CircleAvatar(
                            backgroundColor: Colors.blueGrey[100],
                            child: ClipOval(
                              child: Image.network(
                                user.imageUrl.isEmpty
                                    ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name)}&background=random'
                                    : user.imageUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      user.name
                                          .trim()
                                          .split(' ')
                                          .map((e) => e[0])
                                          .take(2)
                                          .join()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedUserIds.add(user.id);
                              } else {
                                _selectedUserIds.remove(user.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  }

                  return const Center(child: Text("يرجى إعادة المحاولة"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}