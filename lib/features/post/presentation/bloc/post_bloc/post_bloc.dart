import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_chat/features/post/presentation/bloc/post_bloc/post_event.dart';
import 'package:swift_chat/features/post/presentation/bloc/post_bloc/post_state.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecases/posts_usecases/create_post_usecase.dart';
import '../../../domain/usecases/posts_usecases/delete_post_usecase.dart';
import '../../../domain/usecases/posts_usecases/get_posts_usecase.dart';
import '../../../domain/usecases/posts_usecases/update_post_usecase.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase _getPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  StreamSubscription? _postsSubscription;

  PostsBloc({
    required GetPostsUseCase getPostsUseCase,
    required CreatePostUseCase createPostUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required DeletePostUseCase deletePostUseCase,
  })  : _getPostsUseCase = getPostsUseCase,
        _createPostUseCase = createPostUseCase,
        _updatePostUseCase = updatePostUseCase,
        _deletePostUseCase = deletePostUseCase,
        super(PostsInitial()) {
    on<WatchPostsEvent>(_onWatchPosts);
    on<PostsUpdatedEvent>(_onPostsUpdated);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
  }

  Future<void> _onWatchPosts(WatchPostsEvent event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    await emit.forEach<List<PostEntity>>(
      _getPostsUseCase(),
      onData: (posts) => PostsLoaded(posts),
      onError: (error, stackTrace) => PostsError( error.toString()),
    );
  }

  void _onPostsUpdated(PostsUpdatedEvent event, Emitter<PostsState> emit) {
    emit(PostsLoaded(event.posts.cast()));
  }

  Future<void> _onCreatePost(CreatePostEvent event, Emitter<PostsState> emit) async {
    emit(PostActionLoading());
    final result = await _createPostUseCase(event.content, event.imageUrls);
    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (_) => emit(PostActionSuccess()),
    );
  }

  Future<void> _onUpdatePost(UpdatePostEvent event, Emitter<PostsState> emit) async {
    emit(PostActionLoading());
    final result = await _updatePostUseCase(event.postId, event.content);
    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (_) => emit(PostActionSuccess()),
    );
  }

  Future<void> _onDeletePost(DeletePostEvent event, Emitter<PostsState> emit) async {
    emit(PostActionLoading());
    final result = await _deletePostUseCase(event.postId);
    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (_) => emit(PostActionSuccess()),
    );
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}