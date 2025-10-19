import 'package:flutter/material.dart';

class SignupTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final IconData? icon;

  const SignupTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.icon,
  });

  @override
  State<SignupTextField> createState() => _SignupTextFieldState();
}

class _SignupTextFieldState extends State<SignupTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      style: const TextStyle(
        fontFamily: 'Calibri',
        fontSize: 18,
        color: Color(0xFF0F4C78),
      ),
      decoration: InputDecoration(
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: const Color(0xFF0F4C78))
            : null,
        labelText: widget.label,
        labelStyle: const TextStyle(
          fontFamily: 'Calibri',
          fontSize: 18,
          color: Color(0xFF0F4C78),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF0F4C78),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF017C0F),
            width: 2,
          ),
        ),
        // Only show toggle if password field
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF0F4C78),
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class SignupCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SignupCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF31FFB7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
