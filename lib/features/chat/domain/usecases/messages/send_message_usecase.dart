import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
    String roomId,
    String content, {
    String type = 'text',
  }) async {
    return await repository.sendMessage(roomId, content, type: type);
  }
}
