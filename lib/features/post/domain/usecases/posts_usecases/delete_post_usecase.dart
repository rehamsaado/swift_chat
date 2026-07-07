import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/posts_repository.dart';

class DeletePostUseCase {
  final PostsRepository repository;

  const DeletePostUseCase(this.repository);

  Future<Either<Failure, void>> call(String postId) async {
    return await repository.deletePost(postId);
  }
}