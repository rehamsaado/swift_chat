import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/comments_repository.dart';

class DeleteCommentUseCase {
  final CommentsRepository repository;

  const DeleteCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(String commentId) async {
    return await repository.deleteComment(commentId);
  }
}