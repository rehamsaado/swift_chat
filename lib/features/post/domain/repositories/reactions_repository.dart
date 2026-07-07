import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_reaction_entity.dart';

abstract class ReactionsRepository {
  Future<Either<Failure, void>> toggleLike(String postId);

  Future<Either<Failure, List<UserReactionEntity>>> getPostReactions(String postId);
}