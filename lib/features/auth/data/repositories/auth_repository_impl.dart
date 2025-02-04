import 'package:task_management_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:task_management_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      return response['token']; // Ambil token jika berhasil
    } catch (e) {
      throw Exception(e.toString()); // Teruskan error ke lapisan atas
    }
  }
}
