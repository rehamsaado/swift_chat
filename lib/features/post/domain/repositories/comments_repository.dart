import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/comment_entity.dart';

abstract class CommentsRepository {
  Stream<List<CommentEntity>> getPostComments(String postId);

  Future<Either<Failure, void>> addComment(
      String postId,
      String content, {
        String? parentCommentId,
      });

  Future<Either<Failure, void>> deleteComment(String commentId);
}