import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

// عندما يتم جلب المستخدمين بنجاح
  class UsersLoaded extends ChatState {
  final List<ChatEntity> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserDetailsLoaded extends ChatState {
  final ChatEntity user;

  const UserDetailsLoaded(this.user);

  @override
  List<Object?> get props => [user];
}
// حالة خاصة فقط بالغرف النشطة (للصفحة الرئيسية)
class RoomsLoaded extends ChatState {
  final List<ChatEntity> rooms;
  const RoomsLoaded(this.rooms);
  @override
  List<Object?> get props => [rooms];
}
