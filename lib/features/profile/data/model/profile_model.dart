import '../../../../core/exports.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.fullName,
    super.avatarUrl,
    required super.isOnline,
    super.bio,
    super.fcmToken,
    super.updatedAt,
  });

  // 1. تحويل من JSON (قادم من Supabase) إلى Model
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? 'No Name',
      avatarUrl: json['avatar_url'],
      isOnline: json['is_online'] ?? false,
      bio: json['bio'],
      fcmToken: json['fcm_token'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // 2. تحويل من Model إلى JSON (لإرساله إلى Supabase عند التحديث)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'is_online': isOnline,
      'bio': bio,
      'fcm_token': fcmToken,
      // الـ updated_at  يتم تحديثه تلقائياً في السيرفر
    };
  }
}