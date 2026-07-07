import '../../domain/entities/comment_entity.dart';


class CommentModel extends CommentEntity {

  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.userName,
    required super.userImageUrl,
    required super.content,
    super.parentCommentId,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {

    final profiles = json['profiles'] as Map<String, dynamic>? ?? {};

    return CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      userName: profiles['full_name'] as String? ?? 'Unknown User',
      userImageUrl: profiles['avatar_url'] as String? ?? '',
      content: json['content'] as String,
      parentCommentId: json['parent_comment_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'content': content,
      if (parentCommentId != null) 'parent_comment_id': parentCommentId,
      if (id.isNotEmpty) 'id': id,
      if (userId.isNotEmpty) 'user_id': userId,
    };
  }
}