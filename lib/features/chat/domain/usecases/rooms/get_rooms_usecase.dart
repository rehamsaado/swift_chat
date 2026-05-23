import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entities/chat_entity.dart';
import '../../repositories/room_repository.dart';


class GetRoomsUseCase {
  final RoomRepository repository;

  GetRoomsUseCase(this.repository);

  Stream<Either<Failure, List<ChatEntity>>> call()  {
    return  repository.getRooms();
  }
}
