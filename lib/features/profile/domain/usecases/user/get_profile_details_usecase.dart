import 'package:swift_chat/core/exports.dart';


class GetProfileDetailsUseCase {
  final ProfileRepository repository;

  GetProfileDetailsUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call(String userId) async {
    return await repository.getProfileDetails(userId);
  }
}