import 'package:flutter/material.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_bloc/chat_state.dart';
import '../pages/chat_room_page.dart';
import 'app_chat_tile.dart';

class CustomDelegate extends SearchDelegate {
  final ChatBloc chatBloc;

  CustomDelegate({required this.chatBloc});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.colorScheme.surface,
        iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(color: theme.colorScheme.onSurface),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurface),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {

    final theme = Theme.of(context);
    final state = chatBloc.state;


    return Container(
      color: theme.scaffoldBackgroundColor,
      child: _buildBody(context, state, theme),
    );
  }

  Widget _buildBody(BuildContext context, ChatState state, ThemeData theme) {
    if (state is UsersLoaded) {
      final filteredUsers = state.users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (filteredUsers.isEmpty) {
        return Center(
          child: Text(
            "لا يوجد نتائج",
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        );
      }

      return ListView.separated(
        itemCount: filteredUsers.length,
        // استخدام لون الفاصل من الثيم
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: theme.dividerTheme.color,
        ),
        itemBuilder: (context, index) {
          final chat = filteredUsers[index];
          return AppChatTile(
            title: chat.name,
            subTitle: chat.lastMessage.isEmpty
                ? "ابدأ المحادثة الآن"
                : chat.lastMessage,
            imageUrl: chat.imageUrl,
            isOnline: chat.isOnline,
            unreadCount: chat.unreadCount,
            time: "",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatRoomScreen(chatEntity: chat, roomId: chat.id),
                ),
              );
            },
          );
        },
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: theme.colorScheme.primary,
      ),
    );
  }
}