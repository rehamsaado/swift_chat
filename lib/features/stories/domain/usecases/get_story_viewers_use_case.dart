import 'package:dartz/dartz.dart';
import '../repositories/story_repository.dart';
import '../../../../core/error/failures.dart';

class GetStoryViewers {
  final StoryRepository repository;

  GetStoryViewers(this.repository);

  // جلب قائمة المشاهدين للقصة باستخدام الـ storyId
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
    String storyId,
  ) async {
    return await repository.getStoryViewers(storyId);
  }
}
