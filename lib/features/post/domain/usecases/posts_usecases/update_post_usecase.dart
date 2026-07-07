import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/posts_repository.dart';

class UpdatePostUseCase {
  final PostsRepository repository;

  const UpdatePostUseCase(this.repository);

  Future<Either<Failure, void>> call(String postId, String content) async {
    return await repository.updatePost(postId, content);
  }
}