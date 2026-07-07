import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userImageUrl,
    required super.content,
    required super.imageUrls,
    required super.likesCount,
    required super.commentsCount,
    required super.isLikedByMe,
    required super.createdAt,
    super.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final profiles = json['profiles'] as Map<String, dynamic>? ?? {};
    final likesList = json['post_likes'] as List<dynamic>? ?? [];
    final commentsList = json['comments'] as List<dynamic>? ?? [];
    final isLiked = likesList.any((like) => like['user_id'] == currentUserId);

    return PostModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: profiles['full_name'] as String? ?? 'Unknown User',
      userImageUrl: profiles['avatar_url'] as String? ?? '',
      content: json['content'] as String,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      likesCount: likesList.length,
      commentsCount: commentsList.length,
      isLikedByMe: isLiked,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'image_urls': imageUrls,
      if (id.isNotEmpty) 'id': id,
      if (userId.isNotEmpty) 'user_id': userId,
    };
  }
}