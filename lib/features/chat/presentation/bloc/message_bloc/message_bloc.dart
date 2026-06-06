import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // أضفنا هاد عشان نجيب الـ ID
import '../../../domain/entities/message_entity.dart';
import '../../../domain/usecases/messages/get_message_usecase.dart';
import '../../../domain/usecases/messages/mark_messages_as_read_usecase.dart';
import '../../../domain/usecases/messages/send_message_usecase.dart';
import '../../../domain/usecases/messages/upload_chat_image_use_case.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final UploadChatImageUseCase uploadChatImageUseCase;
  final MarkMessagesAsReadUseCase markMessagesAsReadUseCase;

  // معرف المستخدم الحالي لمنع الـ Loop
  final String _myId = Supabase.instance.client.auth.currentUser!.id;

  MessageBloc({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.markMessagesAsReadUseCase,
    required this.uploadChatImageUseCase,
  }) : super(MessageInitial()) {
    on<WatchMessagesStarted>(_onWatchMessagesStarted);
    on<MessageSent>(_onMessageSent);
    on<SendImageMessageStarted>(_onSendImageMessageStarted);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
    on<MessagesStreamError>(_onStreamError);
  }

  Future<void> _onWatchMessagesStarted(
      WatchMessagesStarted event,
      Emitter<MessageState> emit,
      ) async {
    emit(MessageLoading());

    // تحديث أولي عند الدخول
    markMessagesAsReadUseCase(event.roomId);

    // استخدمنا distinct عشان نمنع الـ Loop إذا البيانات ما تغيرت
    await emit.forEach<List<MessageEntity>>(
      getMessagesUseCase(event.roomId).distinct((prev, next) {
        // إذا كان طول القائمة نفسه وأول رسالة وآخر رسالة نفس الشي، يعني ما تغير شي
        if (prev.length != next.length) return false;
        if (prev.isEmpty && next.isEmpty) return true;
        return prev.first.id == next.first.id &&
            prev.last.status == next.last.status;
      }),
      onData: (messages) {
        final unreadFromOthers = messages.where(
                (m) => m.senderId != _myId && m.status != 'read'
        ).toList();

        if (unreadFromOthers.isNotEmpty) {

          markMessagesAsReadUseCase(event.roomId);
        }



        return MessageLoaded(
          messages: List.from(messages),
          dateTime: DateTime.now(),
        );
      },
      onError: (error, stackTrace) => MessageError(error.toString()),
    );
  }

  Future<void> _onMessageSent(MessageSent event, Emitter<MessageState> emit) async {
    final result = await sendMessageUseCase(event.roomId, event.content, type: event.type);
    result.fold(
          (failure) => emit(MessageError(failure.message)),
          (_) => developer.log("Sent", name: 'MessageBloc'),
    );
  }

  Future<void> _onSendImageMessageStarted(SendImageMessageStarted event, Emitter<MessageState> emit) async {
    final uploadResult = await uploadChatImageUseCase(event.imageFile, event.roomId);
    await uploadResult.fold(
          (failure) async => emit(MessageError(failure.message)),
          (imageUrl) async => await sendMessageUseCase(event.roomId, imageUrl, type: 'image'),
    );
  }

  Future<void> _onMarkMessagesAsRead(MarkMessagesAsRead event, Emitter<MessageState> emit) async {
    if (event.roomId.isNotEmpty) await markMessagesAsReadUseCase(event.roomId);
  }

  void _onStreamError(MessagesStreamError event, Emitter<MessageState> emit) => emit(MessageError(event.message));
}