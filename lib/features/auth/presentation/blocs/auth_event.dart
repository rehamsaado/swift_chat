abstract class AuthEvent {}

// حدث تسجيل الدخول
class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);
}

// حدث إنشاء حساب جديد
class RegisterSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  RegisterSubmitted({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

// حدث تسجيل الخروج
class LogoutRequested extends AuthEvent {}