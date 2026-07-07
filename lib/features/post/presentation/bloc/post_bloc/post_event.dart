import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class WatchPostsEvent extends PostsEvent {}

class PostsUpdatedEvent extends PostsEvent {
  final List<dynamic> posts;

  const PostsUpdatedEvent(this.posts);

  @override
  List<Object?> get props => [posts];
}

class CreatePostEvent extends PostsEvent {
  final String content;
  final List<String> imageUrls;

  const CreatePostEvent({required this.content, required this.imageUrls});

  @override
  List<Object?> get props => [content, imageUrls];
}

class UpdatePostEvent extends PostsEvent {
  final String postId;
  final String content;

  const UpdatePostEvent({required this.postId, required this.content});

  @override
  List<Object?> get props => [postId, content];
}

class DeletePostEvent extends PostsEvent {
  final String postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}