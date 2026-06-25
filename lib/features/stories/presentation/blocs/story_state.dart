import '../../domain/entity/story_entity.dart';

abstract class StoryState {}

// 1. الحالة الابتدائية
class StoryInitial extends StoryState {}

// 2. حالة التحميل (لجلب القصص)
class StoryLoading extends StoryState {}

//3. حالة جلب القصص بنجاح)
class StoryLoaded extends StoryState {
  final List<StoryEntity> stories;

  StoryLoaded(this.stories);
}


class StoryActionSuccess extends StoryState {} // لرفع النصوص والصور

class StoryViewedSuccess extends StoryState {}

// 5. حالة الخطأ
class StoryError extends StoryState {
  final String message;

  StoryError(this.message);
}




class StoryViewersLoading extends StoryState {}

class StoryViewersLoaded extends StoryState {
  final List<Map<String, dynamic>> viewers;

  StoryViewersLoaded(this.viewers);
}


class StoryViewersError extends StoryState {
  final String message;

  StoryViewersError(this.message);
}
