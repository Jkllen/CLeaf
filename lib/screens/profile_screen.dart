import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF017C0F),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'No profile data yet.',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF0F4C78),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
