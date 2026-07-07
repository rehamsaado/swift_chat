import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/posts_repository.dart';
import '../data_source/posts_remote_data_source.dart';
import '../model/post_model.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;

  const PostsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<PostModel>> getPosts() {
    return remoteDataSource.getPosts();
  }

  @override
  Future<Either<Failure, void>> createPost(String content, List<String> imageUrls) async {
    try {
      await remoteDataSource.createPost(content, imageUrls);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePost(String postId, String content) async {
    try {
      await remoteDataSource.updatePost(postId, content);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}