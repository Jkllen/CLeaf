import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CLeafBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped;

  const CLeafBottomNav({
    super.key,
    required this.selectedIndex,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF59D46E),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: GoogleFonts.inriaSerif(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.inriaSerif(fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
