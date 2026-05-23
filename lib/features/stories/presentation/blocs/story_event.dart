abstract class StoryEvent {}

// 1. حدث جلب القصص (بيشتغل أول ما نفتح الشاشة)
class GetActiveStoriesEvent extends StoryEvent {}

// 2. حدث رفع قصة صورة
class UploadImageStoryEvent extends StoryEvent {
  final String filePath;
  final String? caption;

  UploadImageStoryEvent({required this.filePath, this.caption});
}
// أضيفي هذا الحدث في نهاية ملف story_event.dart
class GetStoryViewersEvent extends StoryEvent {
  final String storyId;

  GetStoryViewersEvent(this.storyId);
}
// 3. حدث رفع قصة نصية
class UploadTextStoryEvent extends StoryEvent {
  final String text;
  final String backgroundColor;

  UploadTextStoryEvent({required this.text, required this.backgroundColor});
}

// 4. حدث مشاهدة القصة
class MarkStoryAsViewedEvent extends StoryEvent {
  final String storyId;

  MarkStoryAsViewedEvent(this.storyId);
}