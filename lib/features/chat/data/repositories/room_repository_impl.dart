import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/room_repository.dart';
import '../data_source/room_remote_data_source.dart';
import '../model/chat_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatEntity>>> getUsers() async {
    try {
      final data = await remoteDataSource.getAllUsers();
      final users = data.map((json) => ChatModel.fromJson(json)).toList();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure("فشل جلب المستخدمين: $e"));
    }
  }

  @override
  Stream<Either<Failure, List<ChatEntity>>> getRooms() {
    return remoteDataSource.getRoomsStream().map<Either<Failure, List<ChatEntity>>>((data) {
      try {
        final rooms = data.map((json) => ChatModel.fromJson(json)).toList();
        return Right(rooms);
      } catch (e) {
        return Left(ServerFailure("خطأ في تحويل بيانات الغرف: $e"));
      }
    }).handleError((error) {
      return Left(ServerFailure("خطأ في اتصال الـ Stream: $error"));
    });
  }

  @override
  Future<Either<Failure, String>> getOrCreateRoomId(String otherUserId) async {
    try {
      final roomId = await remoteDataSource.getOrCreateRoomId(otherUserId);
      return Right(roomId);
    } catch (e) {
      return Left(ServerFailure("فشل الحصول على معرف الغرفة"));
    }
  }

  @override
  Future<Either<Failure, String>> createGroup({
    required String name,
    required String imageUrl,
    required List<String> memberIds,
  }) async {
    try {
      final roomId = await remoteDataSource.createGroup(name, imageUrl, memberIds);
      return Right(roomId);
    } catch (e) {
      return Left(ServerFailure("فشل إنشاء الغروب: $e"));
    }
  }
}