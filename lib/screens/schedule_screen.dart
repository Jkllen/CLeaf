import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/bottom_nav.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Center(
        child: Text(
          "Schedule Page (Placeholder)",
          style: GoogleFonts.inriaSerif(fontSize: 18),
        ),
      ),
      bottomNavigationBar: const CLeafBottomNav(selectedIndex: 2),
    );
  }
}
