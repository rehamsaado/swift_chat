import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/message_entity.dart';

abstract class MessageRepository {

  Future<Either<Failure, Unit>> sendMessage(
    String roomId,
    String content, {
    String type = 'text',
  });


  Stream<List<MessageEntity>> getMessages(String roomId);


  Future<Either<Failure, String>> uploadChatImage(
    File imageFile,
    String roomId,
  );


  Future<Either<Failure, Unit>> markMessagesAsRead(String roomId);


}
