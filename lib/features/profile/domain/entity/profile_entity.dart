class ProfileEntity {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final bool isOnline;
  final String? bio;
  final String? fcmToken;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.isOnline,
    this.bio,
    this.fcmToken,
    this.updatedAt,
  });
}