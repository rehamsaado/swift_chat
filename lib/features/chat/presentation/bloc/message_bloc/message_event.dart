import 'dart:io';

import 'package:equatable/equatable.dart';


abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class WatchMessagesStarted extends MessageEvent {
  final String roomId;

  const WatchMessagesStarted(this.roomId);

  @override
  List<Object> get props => [roomId];
}



class MessageSent extends MessageEvent {
  final String roomId;
  final String content;
  final String type; // إضافة نوع الرسالة
  const MessageSent(this.roomId, this.content, {this.type = 'text'});

  @override
  List<Object> get props => [roomId, content, type];
}

// الحدث الجديد لإرسال الصور
class SendImageMessageStarted extends MessageEvent {
  final String roomId;
  final File imageFile; // ملف الصورة
  const SendImageMessageStarted(this.roomId, this.imageFile);

  @override
  List<Object> get props => [roomId, imageFile];
}

class MessagesStreamError extends MessageEvent {
  final String message;

  const MessagesStreamError(this.message);

  @override
  List<Object> get props => [message];
}

class MarkMessagesAsRead extends MessageEvent {
  final String roomId;

  const MarkMessagesAsRead(this.roomId);

  @override
  List<Object> get props => [roomId];
}

class WatchPresenceStarted extends MessageEvent {
  final String roomId;

  const WatchPresenceStarted(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class TypingStarted extends MessageEvent {
  final String roomId;

  const TypingStarted(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class TypingStopped extends MessageEvent {
  final String roomId;

  const TypingStopped(this.roomId);

  @override
  List<Object?> get props => [roomId];
}
