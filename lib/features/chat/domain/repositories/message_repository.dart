import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/message_entity.dart';

abstract class MessageRepository {
  // إرسال رسالة جديدة
  Future<Either<Failure, Unit>> sendMessage(
    String roomId,
    String content, {
    String type = 'text',
  });

  // جلب الرسائل بشكل لحظي (Stream)
  Stream<List<MessageEntity>> getMessages(String roomId);

  // رفع الصور داخل الشات
  Future<Either<Failure, String>> uploadChatImage(
    File imageFile,
    String roomId,
  );

  // تحديث حالة القراءة (تصفير العداد)
  Future<Either<Failure, Unit>> markMessagesAsRead(String roomId);


}
