import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/bottom_nav.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Center(
        child: Text(
          "Library Page (Placeholder)",
          style: GoogleFonts.inriaSerif(fontSize: 18),
        ),
      ),
      bottomNavigationBar: const CLeafBottomNav(selectedIndex: 3),
    );
  }
}
