import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_entity.dart';

abstract class RoomRepository {
  // جلب قائمة المستخدمين لبدء محادثة
  Future<Either<Failure, List<ChatEntity>>> getUsers();

  // الحصول على ID الغرفة الحقيقي (UUID)
  Future<Either<Failure, String>> getOrCreateRoomId(String otherUserId);

  // مراقبة قائمة المحادثات (الغرف) في الصفحة الرئيسية
  Stream<Either<Failure, List<ChatEntity>>> getRooms();
}