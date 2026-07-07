import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/comments_repository.dart';

class AddCommentUseCase {
  final CommentsRepository repository;

  const AddCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(
      String postId,
      String content, {
        String? parentCommentId,
      }) async {
    return await repository.addComment(
      postId,
      content,
      parentCommentId: parentCommentId,
    );
  }
}