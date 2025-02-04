import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        'https://reqres.in/api/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw Exception("Email atau password salah");
      } else {
        throw Exception("Terjadi kesalahan. Coba lagi nanti.");
      }
    }
  }
}
