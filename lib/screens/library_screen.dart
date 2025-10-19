import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        backgroundColor: const Color(0xFF017C0F),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'No plant guides yet.',
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
