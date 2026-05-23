import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_active_stories.dart';
import '../../domain/usecases/get_story_viewers_useCase.dart';
import '../../domain/usecases/mark_story_as_viewed.dart';
import '../../domain/usecases/upload_image_story.dart';
import '../../domain/usecases/upload_text_story.dart';
import 'story_event.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  // تعريف الـ Use Cases كمتغيرات نهائية
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
    // تسجيل الـ Handlers لكل حدث (رح نكتبهم دالة دالة)
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
    // 1. أول شي بنخبر الشاشة إننا بلشنا تحميل
    emit(StoryLoading());

    // 2. بننادي الـ Use Case وبنستنى النتيجة (Either)
    final result = await getActiveStoriesUseCase();

    // 3. بنفك تغليف النتيجة باستخدام fold
    result.fold(
      // في حال الـ Left (فشل): بنطلع حالة الخطأ مع الرسالة
      (failure) => emit(StoryError(failure.message)),

      // في حال الـ Right (نجاح): بنبعت القصص للشاشة
      (stories) => emit(StoryLoaded(stories)),
    );
  }

  Future<void> _onUploadImageStory(
    UploadImageStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    // 1. إظهار مؤشر التحميل
    emit(StoryLoading());

    // 2. استدعاء الـ Use Case مع تمرير المسار والكابشن
    final result = await uploadImageStoryUseCase(
      event.filePath,
      caption: event.caption,
    );

    // 3. التعامل مع النتيجة
    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (_) => add(GetActiveStoriesEvent()),
    );
  }

  Future<void> _onUploadTextStory(
    UploadTextStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    // 1. تشغيل اللودينج
    emit(StoryLoading());

    // 2. استدعاء الـ Use Case بتمرير المتغيرات مباشرة (بدون كلاس Params)
    // حسب ما أنت معرفها في الـ Use Case عندك
    final result = await uploadTextStoryUseCase(
      text: event.text,
      backgroundColor: event.backgroundColor,
    );

    // 3. معالجة النتيجة
    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (_) => add(GetActiveStoriesEvent()), // تحديث القائمة فوراً بعد رفع النص
    );
  }

  Future<void> _onMarkStoryAsViewed(
    MarkStoryAsViewedEvent event,
    Emitter<StoryState> emit,
  ) async {
    // 1. استدعاء الـ Use Case بتمرير الـ ID المباشر
    // (هنا لا نحتاج لـ Loading لأن العملية تتم في الخلفية غالباً)
    final result = await markStoryAsViewedUseCase(event.storyId);

    // 2. معالجة النتيجة بهدوء
    result.fold(
      (failure) => print("⚠️ View Error: ${failure.message}"),
      (_) => null, // تم تسجيل المشاهدة بنجاح
    );
  }

  Future<void> _onGetStoryViewers(
    GetStoryViewersEvent event,
    Emitter<StoryState> emit,
  ) async {
    // 1. تشغيل حالة تحميل المشاهدين (منفصلة تماماً لكي لا تضرب شريط الستوريات)
    emit(StoryViewersLoading());

    // 2. استدعاء الـ Use Case
    final result = await getStoryViewersUseCase(event.storyId);

    // 3. معالجة النتيجة
    result.fold(
      (failure) => emit(StoryViewersError(failure.message)),
      (viewers) => emit(StoryViewersLoaded(viewers)),
    );
  }
}
