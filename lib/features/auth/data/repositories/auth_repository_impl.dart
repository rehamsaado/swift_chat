import 'package:supabase/supabase.dart';

import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthResponse> login(String email, String password) async {

    return await remoteDataSource.signIn(email, password);
  }

  @override
  Future<AuthResponse> register(
    String email,
    String password,
    String fullName,
  ) => remoteDataSource.signUp(email, password, fullName);
}
