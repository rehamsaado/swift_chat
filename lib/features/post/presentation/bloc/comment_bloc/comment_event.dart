import 'package:equatable/equatable.dart';
import '../../../domain/entities/comment_entity.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class WatchCommentsEvent extends CommentsEvent {
  final String postId;

  const WatchCommentsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class CommentsUpdatedEvent extends CommentsEvent {
  final List<CommentEntity> comments;

  const CommentsUpdatedEvent(this.comments);

  @override
  List<Object?> get props => [comments];
}

class AddCommentEvent extends CommentsEvent {
  final String postId;
  final String content;
  final String? parentCommentId;

  const AddCommentEvent({
    required this.postId,
    required this.content,
    this.parentCommentId,
  });

  @override
  List<Object?> get props => [postId, content, parentCommentId];
}

class DeleteCommentEvent extends CommentsEvent {
  final String commentId;

  const DeleteCommentEvent(this.commentId);

  @override
  List<Object?> get props => [commentId];
}