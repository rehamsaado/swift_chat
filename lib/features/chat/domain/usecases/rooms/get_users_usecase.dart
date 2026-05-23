import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entities/chat_entity.dart';
import '../../repositories/room_repository.dart';

class GetAllUsersUseCase {
  final RoomRepository repository;

  GetAllUsersUseCase(this.repository);

  Future<Either<Failure, List<ChatEntity>>> call()  {
    return  repository.getUsers();
  }
}
