import 'package:swift_chat/features/chat/domain/repositories/message_repository.dart';

import '../../entities/message_entity.dart';


class GetMessagesUseCase {
  final MessageRepository repository;

  GetMessagesUseCase(this.repository);

  Stream<List<MessageEntity>> call(String roomId) {
    return repository.getMessages(roomId);
  }
}