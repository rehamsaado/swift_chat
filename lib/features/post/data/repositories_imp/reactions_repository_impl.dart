import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/reactions_repository.dart';
import '../data_source/posts_remote_data_source.dart';
import '../model/user_reaction_model.dart';

class ReactionsRepositoryImpl implements ReactionsRepository {
  final PostsRemoteDataSource remoteDataSource;

  const ReactionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> toggleLike(String postId) async {
    try {
      await remoteDataSource.toggleLike(postId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserReactionModel>>> getPostReactions(String postId) async {
    try {
      final remoteReactions = await remoteDataSource.getPostReactions(postId);
      return Right(remoteReactions);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}