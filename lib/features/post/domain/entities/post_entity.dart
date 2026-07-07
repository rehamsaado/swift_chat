  import 'package:equatable/equatable.dart';

  class PostEntity extends Equatable {
    final String id;
    final String userId;
    final String userName;
    final String userImageUrl;
    final String content;
    final List<String> imageUrls;
    final int likesCount;
    final int commentsCount;
    final bool isLikedByMe;
    final DateTime createdAt;
    final DateTime? updatedAt;

    const PostEntity({
      required this.id,
      required this.userId,
      required this.userName,
      required this.userImageUrl,
      required this.content,
      required this.imageUrls,
      required this.likesCount,
      required this.commentsCount,
      required this.isLikedByMe,
      required this.createdAt,
      this.updatedAt,
    });

    @override
    List<Object?> get props => [
      id,
      userId,
      userName,
      userImageUrl,
      content,
      imageUrls,
      likesCount,
      commentsCount,
      isLikedByMe,
      createdAt,
      updatedAt,
    ];
  }