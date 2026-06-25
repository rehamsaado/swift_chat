import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_active_stories.dart';
import '../../domain/usecases/get_story_viewers_use_case.dart';
import '../../domain/usecases/mark_story_as_viewed.dart';
import '../../domain/usecases/upload_image_story.dart';
import '../../domain/usecases/upload_text_story.dart';
import 'story_event.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final GetActiveStories getActiveStoriesUseCase;
  final UploadImageStory uploadImageStoryUseCase;
  final UploadTextStory uploadTextStoryUseCase;
  final MarkStoryAsViewed markStoryAsViewedUseCase;
  final GetStoryViewers getStoryViewersUseCase;

  StoryBloc({
    required this.getActiveStoriesUseCase,
    required this.uploadImageStoryUseCase,
    required this.uploadTextStoryUseCase,
    required this.markStoryAsViewedUseCase,
    required this.getStoryViewersUseCase,
  }) : super(StoryInitial()) {
    on<GetActiveStoriesEvent>(_onGetActiveStories);
    on<UploadImageStoryEvent>(_onUploadImageStory);
    on<UploadTextStoryEvent>(_onUploadTextStory);
    on<MarkStoryAsViewedEvent>(_onMarkStoryAsViewed);
    on<GetStoryViewersEvent>(_onGetStoryViewers);
  }

  Future<void> _onGetActiveStories(
    GetActiveStoriesEvent event,
    Emitter<StoryState> emit,
  ) async {

    emit(StoryLoading());

    final result = await getActiveStoriesUseCase();

    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (stories) => emit(StoryLoaded(stories)),
    );
  }

  Future<void> _onUploadImageStory(
    UploadImageStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryLoading());
    final result = await uploadImageStoryUseCase(
      event.filePath,
      caption: event.caption,
    );
    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (_) => add(GetActiveStoriesEvent()),
    );
  }

  Future<void> _onUploadTextStory(
    UploadTextStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryLoading());
    final result = await uploadTextStoryUseCase(
      text: event.text,
      backgroundColor: event.backgroundColor,
    );
    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (_) => add(GetActiveStoriesEvent()),
    );
  }

  Future<void> _onMarkStoryAsViewed(
    MarkStoryAsViewedEvent event,
    Emitter<StoryState> emit,
  ) async {
    final result = await markStoryAsViewedUseCase(event.storyId);
    result.fold(
      (failure) {},
      (_) => null,
    );
  }

  Future<void> _onGetStoryViewers(
    GetStoryViewersEvent event,
    Emitter<StoryState> emit,
  ) async {

    emit(StoryViewersLoading());


    final result = await getStoryViewersUseCase(event.storyId);


    result.fold(
      (failure) => emit(StoryViewersError(failure.message)),
      (viewers) => emit(StoryViewersLoaded(viewers)),
    );
  }
}
