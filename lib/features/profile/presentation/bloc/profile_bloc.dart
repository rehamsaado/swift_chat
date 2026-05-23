import '../../../../core/exports.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetailsUseCase getProfileDetailsUseCase;
  final UpdateProfileDetailsUseCase updateProfileDetailsUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;

  ProfileBloc({
    required this.getProfileDetailsUseCase,
    required this.updateProfileDetailsUseCase,
    required this.uploadProfileImageUseCase,
  }) : super(ProfileInitial()) {
    // 1. معالجة جلب البيانات
    on<GetProfileDetailsEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await getProfileDetailsUseCase(event.userId);
      result.fold(
        (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
        (profile) => emit(ProfileLoaded(profile)),
      );
    });

    // 2. معالجة تحديث البيانات
    on<UpdateProfileDetailsEvent>((event, emit) async {
      // هنا لا نرسل Loading كامل لكي لا تختفي الصفحة، فقط ننتظر النتيجة
      final result = await updateProfileDetailsUseCase(
        fieldName: event.fieldName,
        value: event.value,
        userId: event.userId,
      );
      result.fold(
        (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
        (_) async {
          // ✅ السر هنا: بعد النجاح، نقوم باستدعاء حدث جلب البيانات مرة أخرى
          add(GetProfileDetailsEvent(event.userId));
          // أو نرسل حالة النجاح إذا كنا نحتاجها للـ SnackBar
          emit(ProfileUpdateSuccess());
        },
      );
    });

    // 3. معالجة رفع الصورة
    on<UploadProfileImageEvent>((event, emit) async {
      emit(ProfileImageUploading());
      final result = await uploadProfileImageUseCase(
        event.imageFile,
        event.userId,
      );
      result.fold(
        (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
        (url) async {

          add(GetProfileDetailsEvent(event.userId));
          emit(ProfileUpdateSuccess());
        },
        // (url) => emit(ProfileImageUploaded(url)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure ? failure.message : "حدث خطأ غير متوقع";
  }
}
