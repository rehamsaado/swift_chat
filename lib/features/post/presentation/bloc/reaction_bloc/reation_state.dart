import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_reaction_entity.dart';

abstract class ReactionsState extends Equatable {
  const ReactionsState();

  @override
  List<Object?> get props => [];
}

class ReactionsInitial extends ReactionsState {}

class ReactionsLoading extends ReactionsState {}

class ReactionsLoaded extends ReactionsState {
  final List<UserReactionEntity> reactions;

  const ReactionsLoaded(this.reactions);

  @override
  List<Object?> get props => [reactions];
}

class ReactionsError extends ReactionsState {
  final String message;

  const ReactionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ToggleLikeSuccess extends ReactionsState {}