import 'package:bloc/bloc.dart';
import 'dart:developer' as developer;

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        // تأكد أن اسم الدالة في الـ repository هو login
        final response = await authRepository.login(
          event.email,
          event.password,
        );

        if (response.user != null) {
          emit(AuthSuccess(response.user!));
        } else {
          emit(AuthFailure("فشل تسجيل الدخول: المستخدم غير موجود"));
        }
      } catch (e) {
        developer.log("LOGIN ERROR DEBUG: $e", name: 'AuthBloc');
        emit(AuthFailure(_mapErrorToMessage(e)));
      }
    });

    //  منطق التسجيل (Register)
    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.register(
          event.email,
          event.password,
          event.fullName,
        );
        if (response.user != null) {
          emit(AuthSuccess(response.user!));
        } else {
          emit(AuthFailure("فشل إنشاء الحساب"));
        }
      } catch (e) {
        emit(AuthFailure(_mapErrorToMessage(e)));
      }
    });
  }
}

String _mapErrorToMessage(dynamic error) {
  final errStr = error.toString().toLowerCase();

  // سوبابيز يرجع هذه الرسالة غالباً عند خطأ البيانات
  if (errStr.contains('invalid login credentials')) {
    return "البريد الإلكتروني أو كلمة المرور غير صحيحة";
  }
  // if (errStr.contains('email not confirmed')) {
  //   return "يرجى تأكيد البريد الإلكتروني أولاً";
  // }
  if (errStr.contains('network') || errStr.contains('socketexception')) {
    return "تعذر الاتصال بالخادم، تأكد من الإنترنت";
  }

  return "خطأ: $error"; // سيظهر لك نص الخطأ الأصلي بدل "غير متوقع" لسهولة الحل
}
