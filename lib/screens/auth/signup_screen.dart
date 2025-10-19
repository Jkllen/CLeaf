import 'package:flutter/material.dart';
import 'package:cleaf/widgets/signup_widgets.dart';
import 'package:cleaf/screens/auth/login_screen.dart';
import 'package:cleaf/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleSignup() async {
    final username = usernameController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService.signup(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Something went wrong')),
      );

      if (result['message'] == "Account created successfully") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),

                // Header row: "SIGN UP" + logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 32,
                        color: Color(0xFF0F4C78),
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 92,
                      height: 83.4,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Username
                SignupTextField(
                  controller: usernameController,
                  label: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 20),

                // First Name
                SignupTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  obscureText: false,
                ),
                const SizedBox(height: 20),

                // Last Name
                SignupTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  obscureText: false,
                ),
                const SizedBox(height: 20),

                // Email
                SignupTextField(
                  controller: emailController,
                  label: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 20),

                // Password
                SignupTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Confirm Password
                SignupTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 50),

                // Sign Up button or loading
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SignupCustomButton(text: 'Sign Up', onPressed: handleSignup),
                const SizedBox(height: 50),

                // Divider
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: Colors.grey[400])),
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
                    Expanded(child: Container(height: 1, color: Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 30),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 16,
                        color: Color(0xFF0F4C78),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Login",
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
