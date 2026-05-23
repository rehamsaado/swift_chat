// import '../../domain/entities/chat_entity.dart';
//
// class ChatModel extends ChatEntity {
//   const ChatModel({
//     required super.id,
//     required super.name,
//     required super.lastMessage,
//     required super.imageUrl,
//     required super.lastMessageTime,
//     required super.unreadCount,
//     required super.lastSenderId,
//     super.bio,
//     super.isOnline, required super.peerId,
//   });
//
//   factory ChatModel.fromJson(Map<String, dynamic> json) {
//     return ChatModel(
//       id: (json['id'] ?? '').toString(),
//
//       // سيبحث عن name (من الـ View) أو full_name (من الجدول الأصلي)
//       name: (json['name'] ?? json['full_name'] ?? 'Unknown User').toString(),
//
//       lastMessage: (json['last_message'] ?? '').toString(),
//
//       // سيبحث عن image_url أو avatar_url
//       imageUrl:
//           (json['image_url'] ?? json['avatar_url'] ?? '').toString().isNotEmpty
//           ? (json['image_url'] ?? json['avatar_url']).toString()
//           : 'https://ui-avatars.com/api/?name=${json['name'] ?? json['full_name'] ?? 'U'}&background=random',
//
//       lastMessageTime: json['last_message_time'] != null
//           ? DateTime.parse(json['last_message_time'].toString())
//           : DateTime.now(),
//
//       unreadCount: int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
//       lastSenderId: (json['last_sender_id'] ?? '').toString(),
//       isOnline: json['is_online'] ?? false,
//       bio: (json['bio'] ?? '').toString(), peerId: '',
//     );
//   }
//
//   factory ChatModel.fromUserRoomsRow(Map<String, dynamic> json) {
//     String? pickId(dynamic v) {
//       if (v == null) return null;
//       final s = v.toString().trim();
//       return s.isEmpty ? null : s;
//     }
//
//     final peerId =
//         pickId(json['other_user_id']) ??
//         pickId(json['peer_id']) ??
//         pickId(json['participant_id']) ??
//         pickId(json['partner_id']) ??
//         pickId(json['counterpart_id']) ??
//         pickId(json['profile_id']) ??
//         pickId(json['user_id']) ??
//         pickId(json['member_id']) ??
//         pickId(json['id']);
//
//     final lastMsg =
//         (json['last_message'] ??
//                 json['last_msg'] ??
//                 json['message_preview'] ??
//                 '')
//             .toString();
//
//     final unread =
//         int.tryParse(
//           json['unread_count']?.toString() ??
//               json['unread']?.toString() ??
//               json['unread_messages']?.toString() ??
//               json['badge_count']?.toString() ??
//               '0',
//         ) ??
//         0;
//
//     return ChatModel(
//       id: peerId ?? '',
//       name: (json['name'] ?? json['full_name'] ?? 'Unknown User').toString(),
//       lastMessage: lastMsg,
//       imageUrl:
//           (json['image_url'] ?? json['avatar_url'] ?? '').toString().isNotEmpty
//           ? (json['image_url'] ?? json['avatar_url']).toString()
//           : 'https://ui-avatars.com/api/?name=${json['name'] ?? json['full_name'] ?? 'U'}&background=random',
//       lastMessageTime: json['last_message_time'] != null
//           ? DateTime.parse(json['last_message_time'].toString())
//           : DateTime.now(),
//       unreadCount: unread,
//       lastSenderId: (json['last_sender_id'] ?? '').toString(),
//       isOnline: json['is_online'] ?? false,
//       bio: (json['bio'] ?? '').toString(),
//     );
//   }
//
//   // تحويل الـ Model إلى Map لإرساله للقاعدة إذا لزم الأمر
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'full_name': name,
//       'last_message': lastMessage,
//       'avatar_url': imageUrl,
//       'last_message_time': lastMessageTime.toIso8601String(),
//       'bio': bio,
//     };
//   }
//
//   ChatEntity toEntity() {
//     return ChatEntity(
//       id: id,
//       name: name,
//       imageUrl: imageUrl,
//       lastMessage: lastMessage,
//       lastMessageTime: lastMessageTime,
//       unreadCount: unreadCount,
//       lastSenderId: lastSenderId,
//       isOnline: isOnline,
//       bio: bio,
//     );
//   }
// }

import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.peerId, // المعرف الأساسي للبروفايل
    required super.name,
    required super.lastMessage,
    required super.imageUrl,
    required super.lastMessageTime,
    required super.unreadCount,
    required super.lastSenderId,
    super.bio,
    super.isOnline,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    // تحديد الـ peerId (إما من peer_id أو id إذا كان الجدول هو profiles)
    final String extractedPeerId = (json['peer_id'] ?? json['id'] ?? '')
        .toString();

    // تحديد الـ roomId (إذا كنا في قائمة البحث يكون هو نفسه الـ peerId مؤقتاً)
    final String extractedRoomId = (json['room_id'] ?? json['id'] ?? '')
        .toString();

    return ChatModel(
      id: extractedRoomId,
      peerId: extractedPeerId,
      name: (json['name'] ?? json['full_name'] ?? 'Unknown User').toString(),
      lastMessage: (json['last_message'] ?? '').toString(),
      imageUrl:
          (json['image_url'] ?? json['avatar_url'] ?? '').toString().isNotEmpty
          ? (json['image_url'] ?? json['avatar_url']).toString()
          : 'https://ui-avatars.com/api/?name=${json['name'] ?? json['full_name'] ?? 'U'}&background=random',
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'].toString())
          : DateTime.now(),
      unreadCount: int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
      lastSenderId: (json['last_sender_id'] ?? '').toString(),
      isOnline: json['is_online'] ?? false,
      bio: (json['bio'] ?? '').toString(),
    );
  }

  // دالة مخصصة لتحويل بيانات "قائمة المحادثات" (User Rooms)
  factory ChatModel.fromUserRoomsRow(Map<String, dynamic> json) {
    return ChatModel(
      id: (json['id'] ?? '').toString(),
      // هذا الـ Room ID
      peerId: (json['peer_id'] ?? '').toString(),
      // هذا الـ User ID للطرف الآخر
      name: (json['full_name'] ?? 'Unknown').toString(),
      lastMessage: (json['last_message'] ?? '').toString(),
      imageUrl: (json['avatar_url'] ?? '').toString(),
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'].toString())
          : DateTime.now(),
      unreadCount: json['unread_count'] ?? 0,
      lastSenderId: (json['last_sender_id'] ?? '').toString(),
      isOnline: json['is_online'] ?? false,
      bio: (json['bio'] ?? '').toString(),
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      peerId: peerId,
      // التأكد من تمرير الـ peerId للـ Entity
      name: name,
      imageUrl: imageUrl,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
      lastSenderId: lastSenderId,
      isOnline: isOnline,
      bio: bio,
    );
  }
}
