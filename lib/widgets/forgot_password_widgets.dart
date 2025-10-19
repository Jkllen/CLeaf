import 'package:flutter/material.dart';

class ForgotPasswordTextField extends StatelessWidget {
  final TextEditingController? controller;

  const ForgotPasswordTextField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontFamily: 'Calibri',
        fontSize: 16,
        color: Color(0xFF0F4C78),
      ),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(
          fontFamily: 'Calibri',
          fontSize: 18,
          color: Color(0xFF0F4C78),
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Calibri',
          fontSize: 18,
          color: Color(0xFF017C0F),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF797979)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF017C0F),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class SendResetButton extends StatelessWidget {
  const SendResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // TODO: implement reset link logic later
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset link sent!'),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF31FFB7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Send Reset Link',
          style: TextStyle(
            fontFamily: 'Calibri',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
