import '../../entities/comment_entity.dart';
import '../../repositories/comments_repository.dart';

class GetPostCommentsUseCase {
  final CommentsRepository repository;

  const GetPostCommentsUseCase(this.repository);

  Stream<List<CommentEntity>> call(String postId) {
    return repository.getPostComments(postId);
  }
}