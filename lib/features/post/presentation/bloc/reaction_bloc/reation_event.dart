import 'package:equatable/equatable.dart';

abstract class ReactionsEvent extends Equatable {
  const ReactionsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleLikeEvent extends ReactionsEvent {
  final String postId;

  const ToggleLikeEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class GetPostReactionsEvent extends ReactionsEvent {
  final String postId;

  const GetPostReactionsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}