import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/reactions_repository.dart';

class ToggleLikeUseCase {
  final ReactionsRepository repository;

  const ToggleLikeUseCase(this.repository);

  Future<Either<Failure, void>> call(String postId) async {
    return await repository.toggleLike(postId);
  }
}