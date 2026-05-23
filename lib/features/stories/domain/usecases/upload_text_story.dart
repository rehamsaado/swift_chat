import 'package:dartz/dartz.dart';
import '../repositories/story_repository.dart';
import '../../../../core/error/failures.dart';

class UploadTextStory {
  final StoryRepository repository;

  UploadTextStory(this.repository);

  Future<Either<Failure, Unit>> call({
    required String text,
    required String backgroundColor,
  }) async {
    return await repository.uploadTextStory(
      text: text,
      backgroundColor: backgroundColor,
    );
  }
}