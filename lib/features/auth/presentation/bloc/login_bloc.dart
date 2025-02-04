import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginBloc extends Cubit<String?> {
	final LoginUseCase loginUseCase;

	LoginBloc(this.loginUseCase): super(null);

	Future<void> login(String email, String password) async {
		try {
			final token = await loginUseCase.execute(email, password);
			emit(token);
		} catch (e) {
			emit(e.toString());
		}
	}
}