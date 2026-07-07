import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Stream<List<PostEntity>> getPosts();

  Future<Either<Failure, void>> createPost(String content, List<String> imageUrls);

  Future<Either<Failure, void>> updatePost(String postId, String content);

  Future<Either<Failure, void>> deletePost(String postId);
}