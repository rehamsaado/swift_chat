import '../../../../core/exports.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfileDetails(String userId);

  Future<Either<Failure, Unit>> updateProfileDetails({
    required String fieldName,
    required dynamic value,
    required String userId,
  });

  Future<Either<Failure, String>> uploadProfileImage(
    File imageFile,
    String userId,
  );
}
