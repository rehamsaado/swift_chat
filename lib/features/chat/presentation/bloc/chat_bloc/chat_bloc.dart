import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/usecases/rooms/get_or_create_roomId_UseCase.dart';
import '../../../domain/usecases/rooms/get_rooms_usecase.dart';
import '../../../domain/usecases/rooms/get_users_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetRoomsUseCase getRoomsUseCase;
  final GetOrCreateRoomIdUseCase getOrCreateRoomIdUseCase;

  ChatBloc({
    required this.getAllUsersUseCase,
    required this.getRoomsUseCase,
    required this.getOrCreateRoomIdUseCase,
  }) : super(ChatInitial()) {
    // 1. جلب كل المستخدمين
    on<GetAllUsersStarted>((event, emit) async {
      emit(ChatLoading());
      final result = await getAllUsersUseCase.call();
      result.fold(
        (f) => emit(ChatError(f.message)),
        (users) => emit(UsersLoaded(users)), // هي بتضل للكل
      );
    });

    // 2. مراقبة الغرف النشطة (Stream)
    on<WatchRoomsStarted>((event, emit) async {
      await emit.forEach<Either<Failure, List<ChatEntity>>>(
        getRoomsUseCase.call(),
        onData: (result) {
          return result.fold(
            (f) => ChatError(f.message),
            (roomsFromStream) =>
                RoomsLoaded(roomsFromStream), // نستخدم RoomsLoaded هنا!
          );
        },
      );
    });
  }

  Future<String> getRoomId(String otherUserId) async {
    final result = await getOrCreateRoomIdUseCase(otherUserId);
    return result.fold(
      (failure) => "", // أو التعامل مع الخطأ حسب رغبتك
      (roomId) => roomId,
    );
  }
}
