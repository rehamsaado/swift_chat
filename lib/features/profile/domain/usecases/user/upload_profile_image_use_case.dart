import '../../../../../core/exports.dart';

class UploadProfileImageUseCase {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<Either<Failure, String>> call(File imageFile, String userId) async {
    return await repository.uploadProfileImage(imageFile, userId);
  }
}
