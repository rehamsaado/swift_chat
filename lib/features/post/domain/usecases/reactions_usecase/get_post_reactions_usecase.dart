import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entities/user_reaction_entity.dart';
import '../../repositories/reactions_repository.dart';

class GetPostReactionsUseCase {
  final ReactionsRepository repository;

  const GetPostReactionsUseCase(this.repository);

  Future<Either<Failure, List<UserReactionEntity>>> call(String postId) async {
    return await repository.getPostReactions(postId);
  }
}