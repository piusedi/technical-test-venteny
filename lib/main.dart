import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/tasks/domain/entities/task.dart';
import 'package:provider/provider.dart';
import 'features/tasks/task_provider.dart';

void main() async {
	final dio = Dio();
	final authRemoteDataSource = AuthRemoteDataSource(dio);
	final authRepository = AuthRepositoryImpl(authRemoteDataSource);
	final loginUseCase = LoginUseCase(authRepository);

	WidgetsFlutterBinding.ensureInitialized();
	await Hive.initFlutter();
	Hive.registerAdapter(TaskStatusAdapter());
	Hive.registerAdapter(TaskAdapter());
	await Hive.openBox<Task>('tasks');

	runApp(MyApp(loginUseCase));
}

class MyApp extends StatefulWidget {
	final LoginUseCase loginUseCase;

	const MyApp(this.loginUseCase, {super.key});

	@override
	_MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.system);

	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider(create: (context) => TaskProvider()),
			],
			child: BlocProvider(
				create: (_) => LoginBloc(widget.loginUseCase),
				child: ValueListenableBuilder<ThemeMode>(
					valueListenable: _themeNotifier,
					builder: (context, themeMode, child) {
						return MaterialApp(
							theme: ThemeData.light().copyWith(
								primaryColor: const Color(0xFFF98A0C),
								scaffoldBackgroundColor: Colors.white,
								appBarTheme: const AppBarTheme(
									backgroundColor: Color(0xFFF98A0C),
									elevation: 0,
								),
							),
							darkTheme: ThemeData.dark().copyWith(
								primaryColor: const Color(0xFF633704),
								scaffoldBackgroundColor: Colors.black,
								appBarTheme: const AppBarTheme(
									backgroundColor: Color(0xFF633704),
									elevation: 0,
								),
								textTheme: const TextTheme(
									bodyLarge: TextStyle(color: Colors.white),
								),
							),
							themeMode: themeMode,
							home: LoginPage(
								onThemeChanged: (newTheme) {
									_themeNotifier.value = newTheme;
								},
							),
						);
					},
				),
			),
		);
	}
}
