import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    super.peerId,
    required super.name,
    required super.lastMessage,
    required super.imageUrl,
    required super.lastMessageTime,
    required super.unreadCount,
    required super.lastSenderId,
    super.isGroup,
    super.createdBy,
    super.bio,
    super.isOnline,
    super.joinedAt,
    super.groupMemberNames,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final bool isGroupChat = json['is_group'] ?? false;
    final String extractedRoomId = (json['room_id'] ?? json['id'] ?? '').toString();
    final String? extractedPeerId = isGroupChat ? null : (json['peer_id'] ?? json['id'] ?? '').toString();

    String displayName = 'Unknown';
    if (isGroupChat) {
      displayName = (json['group_name'] ?? json['name'] ?? 'Unknown Group').toString();
    } else {
      displayName = (json['full_name'] ?? json['name'] ?? 'Unknown User').toString();
    }

    String rawImg = (json['group_avatar_url'] ?? json['image_url'] ?? json['avatar_url'] ?? '').toString();
    String finalImg = rawImg.isNotEmpty
        ? rawImg
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=random';

    List<String> membersList = [];
    if (json['member_names'] != null) {
      membersList = List<String>.from(json['member_names']);
    } else if (json['room_members'] != null) {
      try {
        final List<dynamic> roomMembers = json['room_members'] as List<dynamic>;
        membersList = roomMembers
            .map((m) {
          final profile = m['profiles'] ?? m['user_profile'] ?? m;
          return (profile['full_name'] ?? profile['name'] ?? '').toString();
        })
            .where((name) => name.isNotEmpty)
            .toList();
      } catch (_) {
        membersList = [];
      }
    }

    return ChatModel(
      id: extractedRoomId,
      peerId: extractedPeerId,
      name: displayName,
      lastMessage: (json['last_message'] ?? '').toString(),
      imageUrl: finalImg,
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'].toString())
          : DateTime.now(),
      unreadCount: int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
      lastSenderId: (json['last_sender_id'] ?? '').toString(),
      isGroup: isGroupChat,
      createdBy: json['created_by']?.toString(),
      isOnline: json['is_online'] ?? false,
      bio: json['bio']?.toString(),
      joinedAt: json['joined_at'] != null ? DateTime.parse(json['joined_at'].toString()) : null,
      groupMemberNames: membersList,
    );
  }

  factory ChatModel.fromUserRoomsRow(Map<String, dynamic> json) {
    final bool isGroupChat = json['is_group'] ?? false;
    List<String> membersList = [];
    if (json['member_names'] != null) {
      membersList = List<String>.from(json['member_names']);
    } else if (json['room_members'] != null) {
      try {
        final List<dynamic> roomMembers = json['room_members'] as List<dynamic>;
        membersList = roomMembers
            .map((m) {
          final profile = m['profiles'] ?? m;
          return (profile['full_name'] ?? profile['name'] ?? '').toString();
        })
            .where((name) => name.isNotEmpty)
            .toList();
      } catch (_) {}
    }

    return ChatModel(
      id: (json['id'] ?? '').toString(),
      peerId: isGroupChat ? null : (json['peer_id'] ?? '').toString(),
      name: isGroupChat
          ? (json['group_name'] ?? 'Unknown Group').toString()
          : (json['full_name'] ?? 'Unknown').toString(),
      lastMessage: (json['last_message'] ?? '').toString(),
      imageUrl: isGroupChat
          ? (json['group_avatar_url'] ?? '').toString()
          : (json['avatar_url'] ?? '').toString(),
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'].toString())
          : DateTime.now(),
      unreadCount: json['unread_count'] ?? 0,
      lastSenderId: (json['last_sender_id'] ?? '').toString(),
      isGroup: isGroupChat,
      createdBy: json['created_by']?.toString(),
      isOnline: json['is_online'] ?? false,
      bio: json['bio']?.toString(),
      joinedAt: json['joined_at'] != null ? DateTime.parse(json['joined_at'].toString()) : null,
      groupMemberNames: membersList,
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      peerId: peerId,
      name: name,
      imageUrl: imageUrl,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
      lastSenderId: lastSenderId,
      isGroup: isGroup,
      createdBy: createdBy,
      isOnline: isOnline,
      bio: bio,
      joinedAt: joinedAt,
      groupMemberNames: groupMemberNames,
    );
  }
}