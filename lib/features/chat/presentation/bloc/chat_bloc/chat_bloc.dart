import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/usecases/rooms/get_or_create_room_id_use_case.dart';
import '../../../domain/usecases/rooms/get_rooms_usecase.dart';
import '../../../domain/usecases/rooms/get_users_usecase.dart';
import '../../../domain/usecases/rooms/create_group_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetRoomsUseCase getRoomsUseCase;
  final GetOrCreateRoomIdUseCase getOrCreateRoomIdUseCase;
  final CreateGroupUseCase createGroupUseCase;

  ChatBloc({
    required this.getAllUsersUseCase,
    required this.getRoomsUseCase,
    required this.getOrCreateRoomIdUseCase,
    required this.createGroupUseCase,
  }) : super(ChatInitial()) {
    on<GetAllUsersStarted>((event, emit) async {
      emit(ChatLoading());
      final result = await getAllUsersUseCase.call();
      result.fold(
        (f) => emit(ChatError(f.message)),
        (users) => emit(UsersLoaded(users)),
      );
    });

    on<WatchRoomsStarted>((event, emit) async {
      await emit.forEach<Either<Failure, List<ChatEntity>>>(
        getRoomsUseCase.call(),
        onData: (result) {
          return result.fold(
            (f) => ChatError(f.message),
            (roomsFromStream) => RoomsLoaded(roomsFromStream),
          );
        },
      );
    });

    on<CreateGroupStarted>((event, emit) async {
      emit(ChatLoading());
      final result = await createGroupUseCase.call(
        name: event.name,
        imageUrl: event.imageUrl,
        memberIds: event.memberIds,
      );
      result.fold(
        (f) => emit(ChatError(f.message)),
        (roomId) => emit(GroupCreatedSuccessfully(roomId)),
      );
    });
  }

  Future<String> getRoomId(String otherUserId) async {
    final result = await getOrCreateRoomIdUseCase(otherUserId);
    return result.fold((failure) => "", (roomId) => roomId);
  }
}
