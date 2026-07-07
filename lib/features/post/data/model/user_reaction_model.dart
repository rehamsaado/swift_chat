import '../../domain/entities/user_reaction_entity.dart';

class UserReactionModel extends UserReactionEntity {
  const UserReactionModel({
    required super.userId,
    required super.userName,
    required super.userImageUrl,
  });

  factory UserReactionModel.fromJson(Map<String, dynamic> json) {
    final profiles = json['profiles'] as Map<String, dynamic>? ?? {};

    return UserReactionModel(
      userId: json['user_id'] as String,
      userName: profiles['full_name'] as String? ?? 'Unknown User',
      userImageUrl: profiles['avatar_url'] as String? ?? '',
    );
  }
}