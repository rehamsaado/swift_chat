import 'package:dartz/dartz.dart';
import '../entity/story_entity.dart';
import '../repositories/story_repository.dart';
import '../../../../core/error/failures.dart';

class GetActiveStories {
  final StoryRepository repository;

  GetActiveStories(this.repository);

  Future<Either<Failure, List<StoryEntity>>> call() async {
    return await repository.getActiveStories();
  }
}