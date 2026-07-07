import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/comments_usecases/add_comment_usecase.dart';
import '../../../domain/usecases/comments_usecases/delete_comment_usecase.dart';
import '../../../domain/usecases/comments_usecases/get_post_comments_usecase.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetPostCommentsUseCase _getPostCommentsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;

  StreamSubscription? _commentsSubscription;

  CommentsBloc({
    required GetPostCommentsUseCase getPostCommentsUseCase,
    required AddCommentUseCase addCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
  })  : _getPostCommentsUseCase = getPostCommentsUseCase,
        _addCommentUseCase = addCommentUseCase,
        _deleteCommentUseCase = deleteCommentUseCase,
        super(CommentsInitial()) {
    on<WatchCommentsEvent>(_onWatchComments);
    on<CommentsUpdatedEvent>(_onCommentsUpdated);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
  }

  void _onWatchComments(WatchCommentsEvent event, Emitter<CommentsState> emit) {
    emit(CommentsLoading());
    _commentsSubscription?.cancel();

    _commentsSubscription = _getPostCommentsUseCase(event.postId).listen(
          (comments) => add(CommentsUpdatedEvent(comments)),
      onError: (error) => emit(CommentsError(error.toString())),
    );
  }

  void _onCommentsUpdated(CommentsUpdatedEvent event, Emitter<CommentsState> emit) {
    emit(CommentsLoaded(event.comments));
  }

  Future<void> _onAddComment(AddCommentEvent event, Emitter<CommentsState> emit) async {
    emit(CommentActionLoading());
    final result = await _addCommentUseCase(
      event.postId,
      event.content,
      parentCommentId: event.parentCommentId,
    );
    result.fold(
          (failure) => emit(CommentsError(failure.message)),
          (_) => emit(CommentActionSuccess()),
    );
  }

  Future<void> _onDeleteComment(DeleteCommentEvent event, Emitter<CommentsState> emit) async {
    emit(CommentActionLoading());
    final result = await _deleteCommentUseCase(event.commentId);
    result.fold(
          (failure) => emit(CommentsError(failure.message)),
          (_) => emit(CommentActionSuccess()),
    );
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }
}