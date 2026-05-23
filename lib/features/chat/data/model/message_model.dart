import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    required super.content,
    required super.type,
    required super.createdAt,
    required super.status,      // الحقل الجديد
    super.deliveredAt,
    super.readAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      roomId: map['room_id'],
      senderId: map['sender_id'],
      content: map['content'],
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
      status: map['status'] ?? 'sent', // القيمة الافتراضية
      deliveredAt: map['delivered_at'] != null
          ? DateTime.parse(map['delivered_at'])
          : null,
      readAt: map['read_at'] != null
          ? DateTime.parse(map['read_at'])
          : null,
    );
  }
  // داخل كلاس MessageModel
  factory MessageModel.fromJson(Map<String, dynamic> map) { // غيري fromMap لـ fromJson
    return MessageModel(
      id: map['id'],
      roomId: map['room_id'],
      senderId: map['sender_id'],
      content: map['content'],
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
      status: map['status'] ?? 'sent',
      deliveredAt: map['delivered_at'] != null
          ? DateTime.parse(map['delivered_at'])
          : null,
      readAt: map['read_at'] != null
          ? DateTime.parse(map['read_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'type': type,
      'status': status,
      // الـ id والـ created_at غالباً بيتولدوا بالسيرفر
    };
  }
}