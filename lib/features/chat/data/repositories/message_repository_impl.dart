import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../data_source/message_remote_data_source.dart';


class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> sendMessage(
    String roomId,
    String content, {
    String type = 'text',
  }) async {
    try {
      await remoteDataSource.sendMessage(
        roomId: roomId,
        content: content,
        type: type,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("فشل إرسال الرسالة: $e"));
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(String roomId) {
    return remoteDataSource.getMessages(roomId);
  }

  @override
  Future<Either<Failure, String>> uploadChatImage(
    File imageFile,
    String roomId,
  ) async {
    try {
      final imageUrl = await remoteDataSource.uploadChatImage(
        imageFile,
        roomId,
      );
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure("فشل رفع الصورة: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> markMessagesAsRead(String roomId) async {
    try {
      await remoteDataSource.markMessagesAsRead(roomId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("فشل تحديث حالة القراءة: $e"));
    }
  }
}
