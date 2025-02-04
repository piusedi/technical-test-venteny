import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import 'package:task_management_app/features/tasks/presentation/dashboard_page.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const LoginPage({required this.onThemeChanged, Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController..text = 'eve.holt@reqres.in',
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _isButtonPressed ? _validateEmail(emailController.text) : null,
              ),
            ),
            TextField(
              controller: passwordController..text = 'cityslicka',
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _isButtonPressed ? _validatePassword(passwordController.text) : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onThemeChanged(
                  Theme.of(context).brightness == Brightness.dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                );
              },
              child: const Text('Toggle Theme'),
            ),
            BlocConsumer<LoginBloc, String?>(
              listener: (context, state) {
                if (state != null && state.contains("Exception")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.replaceAll("Exception: ", ""))),
                  );
                } else if (state != null && state.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isButtonPressed = true;
                    });
                    if (_validateEmail(emailController.text) == null &&
                        _validatePassword(passwordController.text) == null) {
                      context.read<LoginBloc>().login(
                            emailController.text,
                            passwordController.text,
                          );
                    }
                  },
                  child: const Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Email validation
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!EmailValidator.validate(email)) {
      return 'Invalid email';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}
