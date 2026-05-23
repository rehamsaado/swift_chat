import '../../../../core/exports.dart';

abstract class ProfileEvent {}

// حدث جلب بيانات البروفايل عند فتح الصفحة
class GetProfileDetailsEvent extends ProfileEvent {
  final String userId;
  GetProfileDetailsEvent(this.userId);
}

// حدث تحديث حقل معين
class UpdateProfileDetailsEvent extends ProfileEvent {
  final String fieldName;
  final dynamic value;
  final String userId;

  UpdateProfileDetailsEvent({
    required this.fieldName,
    required this.value,
    required this.userId,
  });
}

// حدث رفع الصورة الشخصية
class UploadProfileImageEvent extends ProfileEvent {
  final File imageFile;
  final String userId;

  UploadProfileImageEvent({required this.imageFile, required this.userId});
}