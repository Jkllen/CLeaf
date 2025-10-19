import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Login screen-specific text field
class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 42,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: obscureText ? const Icon(Icons.lock, color: AppColors.primary) 
                                  : const Icon(Icons.person, color: AppColors.primary),
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Calibri',
            fontSize: 18,
            color: Color(0xFF0F4C78),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0F4C78)),
          ),
        ),
      ),
    );
  }
}

/// Login screen-specific custom button
class LoginCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LoginCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF31FFB7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Calibri',
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
