import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

// لجلب كل المستخدمين (للصفحة الرئيسية)
class GetAllUsersStarted extends ChatEvent {}

// لجلب مستخدم واحد فقط (لغرفة الدردشة)
class GetUserDetailsEvent extends ChatEvent {
  final String userId;
  const GetUserDetailsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}


class UpdateProfileFieldEvent extends ChatEvent {
  final String userId;
  final String fieldName;
  final dynamic value;

  const UpdateProfileFieldEvent({
    required this.userId,
    required this.fieldName,
    required this.value
  });

  @override
  List<Object?> get props => [userId, fieldName, value];
}

class WatchRoomsStarted extends ChatEvent {}
class UploadProfileImageEvent extends ChatEvent {
  final File imageFile;
  final String userId;

  const UploadProfileImageEvent({required this.imageFile, required this.userId});

  @override
  List<Object?> get props => [imageFile, userId];
}