import 'package:dartz/dartz.dart';
import '../../domain/entity/story_entity.dart';
import '../../domain/repositories/story_repository.dart';

import '../../../../core/error/failures.dart';
import '../data_source/story_remote_data_source.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;

  StoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StoryEntity>>> getActiveStories() async {
    try {

      final remoteStories = await remoteDataSource.getActiveStories();


      return Right(remoteStories);
    } catch (e) {

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getStoryViewers(
    String storyId,
  ) async {
    try {
      final result = await remoteDataSource.getStoryViewers(storyId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> uploadImageStory(
    String filePath, {
    String? caption,
  }) async {
    try {
      // 1. استدعاء الدالة من الـ Data Source
      await remoteDataSource.uploadImageStory(filePath, caption: caption);


      return const Right(unit);
    } catch (e) {

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> uploadTextStory({
    required String text,
    required String backgroundColor,
  }) async {
    try {

      await remoteDataSource.uploadTextStory(
        text: text,
        backgroundColor: backgroundColor,
      );


      return const Right(unit);
    } catch (e) {

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markStoryAsViewed(String storyId) async {
    try {
      await remoteDataSource.markStoryAsViewed(storyId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
