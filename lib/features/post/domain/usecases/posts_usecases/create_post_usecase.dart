import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/posts_repository.dart';

class CreatePostUseCase {
  final PostsRepository repository;

  const CreatePostUseCase(this.repository);

  Future<Either<Failure, void>> call(String content, List<String> imageUrls) async {
    return await repository.createPost(content, imageUrls);
  }
}