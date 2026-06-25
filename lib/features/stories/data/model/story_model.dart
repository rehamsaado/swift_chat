import '../../domain/entity/story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.userId,
    required super.contentType,
    super.mediaUrl,
    super.textContent,
    super.backgroundColor,
    super.caption,
    required super.createdAt,
    required super.expiresAt,
    super.fullName,
    super.avatarUrl,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    final profileJson = json['profiles'] as Map<String, dynamic>?;

    return StoryModel(
      id: json['id'],
      userId: json['user_id'],
      contentType: json['content_type'],
      mediaUrl: json['media_url'],

      textContent: json['content_type'] == 'text' ? json['caption'] : null,
      backgroundColor: json['background_color'],
      caption: json['content_type'] == 'image' ? json['caption'] : null,
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: DateTime.parse(json['expires_at']),

      fullName: profileJson?['full_name'],
      avatarUrl: profileJson?['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'content_type': contentType,
      'media_url': mediaUrl,
      'caption': textContent ?? caption,
      'background_color': backgroundColor,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}