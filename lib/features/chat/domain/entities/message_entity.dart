import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final String type;
  final DateTime createdAt;
  final String status;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  const MessageEntity({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.status,
    this.deliveredAt,
    this.readAt,
  });

  @override
  List<Object?> get props => [
    id,
    roomId,
    senderId,
    content,
    type,
    createdAt,
    status,
    deliveredAt,
    readAt,
  ];
}