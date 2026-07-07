import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String content;
  final String? parentCommentId;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.content,
    this.parentCommentId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    postId,
    userId,
    userName,
    userImageUrl,
    content,
    parentCommentId,
    createdAt,
  ];
}