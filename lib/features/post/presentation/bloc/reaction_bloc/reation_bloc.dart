import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_chat/features/post/presentation/bloc/reaction_bloc/reation_event.dart';
import 'package:swift_chat/features/post/presentation/bloc/reaction_bloc/reation_state.dart';
import '../../../domain/usecases/reactions_usecase/get_post_reactions_usecase.dart';
import '../../../domain/usecases/reactions_usecase/toggle_like_usecase.dart';


class ReactionsBloc extends Bloc<ReactionsEvent, ReactionsState> {
  final ToggleLikeUseCase _toggleLikeUseCase;
  final GetPostReactionsUseCase _getPostReactionsUseCase;

  ReactionsBloc({
    required ToggleLikeUseCase toggleLikeUseCase,
    required GetPostReactionsUseCase getPostReactionsUseCase,
  })  : _toggleLikeUseCase = toggleLikeUseCase,
        _getPostReactionsUseCase = getPostReactionsUseCase,
        super(ReactionsInitial()) {
    on<ToggleLikeEvent>(_onToggleLike);
    on<GetPostReactionsEvent>(_onGetPostReactions);
  }

  Future<void> _onToggleLike(ToggleLikeEvent event, Emitter<ReactionsState> emit) async {
    final result = await _toggleLikeUseCase(event.postId);
    result.fold(
          (failure) => emit(ReactionsError(failure.message)),
          (_) => emit(ToggleLikeSuccess()),
    );
  }

  Future<void> _onGetPostReactions(GetPostReactionsEvent event, Emitter<ReactionsState> emit) async {
    emit(ReactionsLoading());
    final result = await _getPostReactionsUseCase(event.postId);
    result.fold(
          (failure) => emit(ReactionsError(failure.message)),
          (reactions) => emit(ReactionsLoaded(reactions)),
    );
  }
}