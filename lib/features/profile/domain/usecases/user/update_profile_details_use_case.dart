import '../../../../../core/exports.dart';

class UpdateProfileDetailsUseCase {
  final ProfileRepository repository;

  UpdateProfileDetailsUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String fieldName,
    required dynamic value,
    required String userId,
  }) async {
    return await repository.updateProfileDetails(
      fieldName: fieldName,
      value: value,
      userId: userId,
    );
  }
}
