import 'package:dartz/dartz.dart';
import '../repositories/story_repository.dart';
import '../../../../core/error/failures.dart';

class MarkStoryAsViewed {
  final StoryRepository repository;

  MarkStoryAsViewed(this.repository);

  // تمرير الـ storyId للـ Repository لتسجيل المشاهدة
  Future<Either<Failure, Unit>> call(String storyId) async {
    return await repository.markStoryAsViewed(storyId);
  }
}