import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String name;
  final String lastMessage;
  final String imageUrl;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String lastSenderId;
  final bool isGroup;
  final String? createdBy;
  final String? peerId;
  final bool isOnline;
  final String? bio;
  final DateTime? joinedAt;
  final List<String> groupMemberNames;

  const ChatEntity({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.lastSenderId,
    this.isGroup = false,
    this.createdBy,
    this.peerId,
    this.isOnline = false,
    this.bio,
    this.joinedAt,
    this.groupMemberNames = const [],
  });

  ChatEntity copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? imageUrl,
    DateTime? lastMessageTime,
    int? unreadCount,
    String? lastSenderId,
    bool? isGroup,
    String? createdBy,
    String? peerId,
    bool? isOnline,
    String? bio,
    DateTime? joinedAt,
    List<String>? groupMemberNames,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      imageUrl: imageUrl ?? this.imageUrl,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      isGroup: isGroup ?? this.isGroup,
      createdBy: createdBy ?? this.createdBy,
      peerId: peerId ?? this.peerId,
      isOnline: isOnline ?? this.isOnline,
      bio: bio ?? this.bio,
      joinedAt: joinedAt ?? this.joinedAt,
      groupMemberNames: groupMemberNames ?? this.groupMemberNames,
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
    lastSenderId,
    isGroup,
    createdBy,
    peerId,
    isOnline,
    bio,
    joinedAt,
    groupMemberNames,
  ];
}