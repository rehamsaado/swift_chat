import '../../../../core/exports.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfileDetails(
    String userId,
  ) async {
    try {
      final profile = await remoteDataSource.getProfileDetails(userId);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfileDetails({
    required String fieldName,
    required dynamic value,
   required String userId,
  }) async {
    try {
      await remoteDataSource.updateProfileDetails( fieldName: fieldName, value: value, userId: userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(
    File imageFile,
    String userId,
  ) async {
    try {
      // الـ Repository يحدد "المنطق" فقط (مثل اسم الملف)
      final fileName =
          'avatar_$userId\_${DateTime.now().millisecondsSinceEpoch}.png';

      // يطلب من الـ DataSource التنفيذ ويستلم "الرابط" جاهزاً
      final String newImageUrl = await remoteDataSource.uploadProfileImage(
        imageFile,
        fileName,
      );

      // يطلب تحديث البيانات (أيضاً عبر DataSource)
      await remoteDataSource.updateProfileDetails(
        fieldName: 'avatar_url',
        value: newImageUrl,
        userId: userId,
      );

      return Right(newImageUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
