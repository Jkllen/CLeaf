import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/bottom_nav.dart';

class AddPlantScreen extends StatelessWidget {
  const AddPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plant'),
      ),
      body: Center(
        child: Text(
          "Add Plant Page (Placeholder)",
          style: GoogleFonts.inriaSerif(fontSize: 18),
        ),
      ),
      bottomNavigationBar: const CLeafBottomNav(selectedIndex: 1),
    );
  }
}
