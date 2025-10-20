import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Text(
          "Profile Page (Placeholder)",
          style: GoogleFonts.inriaSerif(fontSize: 18),
        ),
      ),
      bottomNavigationBar: const CLeafBottomNav(selectedIndex: 4),
    );
  }
}
