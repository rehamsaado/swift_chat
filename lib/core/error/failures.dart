import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// خطأ في الاتصال بالخادم أو قاعدة البيانات (Supabase)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// خطأ في الاتصال بالإنترنت
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

// خطأ خاص بالصلاحيات (مثل إذا حاول مستخدم دخول غرفة ليس عضواً فيها)
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}