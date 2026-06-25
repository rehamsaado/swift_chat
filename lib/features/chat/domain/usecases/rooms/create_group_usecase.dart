import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/room_repository.dart';

class CreateGroupUseCase {
  final RoomRepository repository;

  const CreateGroupUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String name,
    required String imageUrl,
    required List<String> memberIds,
  }) async {
    return await repository.createGroup(
      name: name,
      imageUrl: imageUrl,
      memberIds: memberIds,
    );
  }
}