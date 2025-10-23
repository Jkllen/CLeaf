import 'package:flutter/material.dart';
import 'package:cleaf/widgets/login_widgets.dart';
import 'package:cleaf/screens/auth/signup_screen.dart';
import 'package:cleaf/screens/auth/forgot_password_screen.dart';
import 'package:cleaf/services/auth_service.dart';
import 'package:cleaf/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController= TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final result = await AuthService.login(
      username: username,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Something went wrong')),
      );
    
    if (result['success'] == true) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFF59FFBD)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 284,
                  height: 241,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 50),
                // Username field
                LoginTextField(controller: usernameController, label: 'Username'),
                const SizedBox(height: 20),
                // Password field
                LoginTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 16,
                        color: Color(0xFF017C0F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login button
                LoginCustomButton(text: 'Login', onPressed: handleLogin),
                const SizedBox(height: 15),
                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'or',
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 16,
                        color: Color(0xFF0F4C78),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(height: 1, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Create account link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 16,
                        color: Color(0xFF0F4C78),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 16,
                          color: Color(0xFF017C0F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
