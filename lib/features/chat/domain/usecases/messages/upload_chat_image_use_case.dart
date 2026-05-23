import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repositories/message_repository.dart';

class UploadChatImageUseCase {
  final MessageRepository repository;

  UploadChatImageUseCase(this.repository);

  Future<Either<Failure, String>> call(File imageFile, String roomId) {
    return repository.uploadChatImage(imageFile, roomId);
  }
}
