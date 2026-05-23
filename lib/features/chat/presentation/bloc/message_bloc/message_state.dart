import 'package:equatable/equatable.dart';

import '../../../domain/entities/message_entity.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => []; // جعلناها تدعم القيم الفارغة اختياريًا
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageEntity> messages;


  // إضافة timestamp تجعل الحالة "فريدة" دائماً عند كل تحديث
  final DateTime dateTime;

  const MessageLoaded({
    required this.messages,

    required this.dateTime, // اجعليها مطلوبة
  });

  @override
  List<Object?> get props => [messages, dateTime];

  MessageLoaded copyWith({
    List<MessageEntity>? messages,
    DateTime? dateTime,
  }) {
    return MessageLoaded(
      messages: messages ?? this.messages,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object?> get props => [message]; // لضمان تحديث الواجهة إذا تغير نص الخطأ
}
