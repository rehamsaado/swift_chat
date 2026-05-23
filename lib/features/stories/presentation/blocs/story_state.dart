import '../../domain/entity/story_entity.dart';

abstract class StoryState {}

// 1. الحالة الابتدائية
class StoryInitial extends StoryState {}

// 2. حالة التحميل (لجلب القصص)
class StoryLoading extends StoryState {}

// 3. حالة جلب القصص بنجاح (تحمل معها قائمة القصص)
class StoryLoaded extends StoryState {
  final List<StoryEntity> stories;

  StoryLoaded(this.stories);
}

// 4. الحالات المنفصلة للعمليات (لكي لا تتضارب مع الـ StoryLoaded)
class StoryActionSuccess extends StoryState {} // لرفع النصوص والصور

class StoryViewedSuccess extends StoryState {} // مخصصة فقط للمشاهدة!

// 5. حالة الخطأ
class StoryError extends StoryState {
  final String message;

  StoryError(this.message);
}

// أضيفي هذه الحالات في نهاية ملف story_state.dart

// حالة تحميل قائمة المشاهدين
class StoryViewersLoading extends StoryState {}

// حالة نجاح جلب المشاهدين (تحمل قائمة الـ Maps التي تحتوي على الاسم والصورة)
class StoryViewersLoaded extends StoryState {
  final List<Map<String, dynamic>> viewers;

  StoryViewersLoaded(this.viewers);
}

// حالة فشل جلب المشاهدين
class StoryViewersError extends StoryState {
  final String message;

  StoryViewersError(this.message);
}
