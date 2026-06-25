import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_entity.dart';

abstract class RoomRepository {
  Future<Either<Failure, List<ChatEntity>>> getUsers();

  Future<Either<Failure, String>> getOrCreateRoomId(String otherUserId);

  Stream<Either<Failure, List<ChatEntity>>> getRooms();

  Future<Either<Failure, String>> createGroup({
    required String name,
    required String imageUrl,
    required List<String> memberIds,
  });
}