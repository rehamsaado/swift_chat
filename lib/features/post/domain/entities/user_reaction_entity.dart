import 'package:equatable/equatable.dart';

class UserReactionEntity extends Equatable {
  final String userId;
  final String userName;
  final String userImageUrl;

  const UserReactionEntity({
    required this.userId,
    required this.userName,
    required this.userImageUrl,
  });

  @override
  List<Object?> get props => [userId, userName, userImageUrl];
}