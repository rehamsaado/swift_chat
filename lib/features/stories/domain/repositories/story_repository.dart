import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/story_entity.dart';

abstract class StoryRepository {
  Future<Either<Failure, List<StoryEntity>>> getActiveStories();

  Future<Either<Failure, Unit>> uploadImageStory(String filePath,{String? caption});

  Future<Either<Failure, Unit>> uploadTextStory({
    required String text,
    required String backgroundColor,
  });

  Future<Either<Failure, Unit>> markStoryAsViewed(String storyId);

  Future<Either<Failure, List<Map<String, dynamic>>>> getStoryViewers(String storyId);
}