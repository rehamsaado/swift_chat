import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/room_repository.dart';

class GetOrCreateRoomIdUseCase {
  final RoomRepository repository;

  GetOrCreateRoomIdUseCase(this.repository);

  Future<Either<Failure, String>> call(String otherUserId) async {
    return await repository.getOrCreateRoomId(otherUserId);
  }
}
