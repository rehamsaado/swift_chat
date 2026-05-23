import 'package:dartz/dartz.dart';
import '../repositories/story_repository.dart';
import '../../../../core/error/failures.dart';

class UploadImageStory {
  final StoryRepository repository;

  UploadImageStory(this.repository);

  Future<Either<Failure, Unit>> call(String filePath,{String? caption}) async {
    return await repository.uploadImageStory(filePath);
  }
}