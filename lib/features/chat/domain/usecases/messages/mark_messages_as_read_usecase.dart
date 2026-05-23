import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';

import '../../repositories/message_repository.dart';

class MarkMessagesAsReadUseCase {
  final MessageRepository repository;

  MarkMessagesAsReadUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String receiverId) {
    return repository.markMessagesAsRead(receiverId);
  }
}