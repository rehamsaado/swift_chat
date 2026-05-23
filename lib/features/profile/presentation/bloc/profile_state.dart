import '../../../../core/exports.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// حالة خاصة لرفع الصورة لإظهار Loading صغير فوق الصورة فقط
class ProfileImageUploading extends ProfileState {}

class ProfileImageUploaded extends ProfileState {
  final String imageUrl;
  ProfileImageUploaded(this.imageUrl);
}

class ProfileUpdateSuccess extends ProfileState {}