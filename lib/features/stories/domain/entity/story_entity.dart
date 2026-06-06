import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final String id;
  final String userId;
  final String contentType;
  final String? mediaUrl;
  final String? textContent;
  final String? backgroundColor;
  final String? caption;
  final DateTime createdAt;
  final DateTime expiresAt;

  // الحقول الجديدة لبيانات صاحب الستوري ( من جدول profiles)
  final String? fullName;
  final String? avatarUrl;

  const StoryEntity({
    required this.id,
    required this.userId,
    required this.contentType,
    this.mediaUrl,
    this.textContent,
    this.backgroundColor,
    this.caption,
    required this.createdAt,
    required this.expiresAt,
    this.fullName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    contentType,
    mediaUrl,
    textContent,
    backgroundColor,
    caption,
    createdAt,
    expiresAt,
    fullName,
    avatarUrl,
  ];
}
