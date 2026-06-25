import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class GetAllUsersStarted extends ChatEvent {}

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
    required this.value,
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

class CreateGroupStarted extends ChatEvent {
  final String name;
  final String imageUrl;
  final List<String> memberIds;

  const CreateGroupStarted({
    required this.name,
    required this.imageUrl,
    required this.memberIds,
  });

  @override
  List<Object?> get props => [name, imageUrl, memberIds];
}