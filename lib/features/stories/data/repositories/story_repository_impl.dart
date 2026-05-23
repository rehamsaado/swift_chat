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
      // 1. نطلب البيانات من الـ Data Source (بترجع List<StoryModel>)
      final remoteStories = await remoteDataSource.getActiveStories();

      // 2. لأن الـ Model يورث من الـ Entity، بنقدر نرجعها فوراً كـ Right
      return Right(remoteStories);
    } catch (e) {
      print("🚨🚨 ERROR IN GET_ACTIVE_STORIES: $e 🚨🚨");
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

      // 2. في حال النجاح، نرجع Right مع قيمة unit (التي تعني نجاح بدون بيانات)
      return const Right(unit);
    } catch (e) {
      // 3. في حال حدوث أي خطأ تقني، نرجعه كـ Left Failure
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> uploadTextStory({
    required String text,
    required String backgroundColor,
  }) async {
    try {
      // 1. تمرير البيانات للـ Data Source
      await remoteDataSource.uploadTextStory(
        text: text,
        backgroundColor: backgroundColor,
      );

      // 2. إرجاع نجاح (Unit)
      return const Right(unit);
    } catch (e) {
      print("DEBUG: Story Repository Error -> $e");
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
