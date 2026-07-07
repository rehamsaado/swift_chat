import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';

class GetPostsUseCase {
  final PostsRepository repository;

  const GetPostsUseCase(this.repository);

  Stream<List<PostEntity>> call() {
    return repository.getPosts();
  }
}