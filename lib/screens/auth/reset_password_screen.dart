import 'package:flutter/material.dart';
import 'package:cleaf/services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String userId;
  final String token;

  const ResetPasswordScreen({super.key, required this.userId, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isLoading = false;

  void handleResetPassword() async {
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AuthService.resetPassword(
        userId: widget.userId,
        token: widget.token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Something went wrong')),
      );

      if (result['message'] == "Password reset successful!") {
        Navigator.pop(context); // go back to login
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error resetting password")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Reset Password",
              style: TextStyle(
                fontFamily: 'Calibri',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : handleResetPassword,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
