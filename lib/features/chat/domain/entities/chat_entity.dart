import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String name;
  final String peerId;
  final String lastMessage;
  final String imageUrl;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final String? bio;
  final String? phoneNumber;
  final DateTime? joinedAt;
  final String lastSenderId;

  const ChatEntity({
    required this.peerId,
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.lastMessageTime,
    required this.unreadCount,
    this.isOnline = false,
    this.bio,
    this.phoneNumber,
    this.joinedAt,
    required this.lastSenderId,
  });

  // أضيفي هذه الدالة هنا
  ChatEntity copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? imageUrl,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isOnline,
    String? bio,
    String? lastSenderId,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      imageUrl: imageUrl ?? this.imageUrl,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      bio: bio ?? this.bio,
      lastSenderId: lastSenderId ?? this.lastSenderId, peerId: peerId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    lastMessage,
    imageUrl,
    lastMessageTime,
    unreadCount,
    isOnline,
    bio,
    phoneNumber,
    joinedAt,
    lastSenderId,
    peerId
  ];
}
