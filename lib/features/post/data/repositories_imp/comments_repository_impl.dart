import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/comments_repository.dart';
import '../data_source/posts_remote_data_source.dart';
import '../model/comment_model.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final PostsRemoteDataSource remoteDataSource;

  const CommentsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<CommentModel>> getPostComments(String postId) {
    return remoteDataSource.getPostComments(postId);
  }

  @override
  Future<Either<Failure, void>> addComment(
      String postId,
      String content, {
        String? parentCommentId,
      }) async {
    try {
      await remoteDataSource.addComment(postId, content, parentCommentId: parentCommentId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}