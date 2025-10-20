import 'package:flutter/material.dart';

class CLeafBottomNav extends StatelessWidget {
  final int selectedIndex;

  const CLeafBottomNav({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/add-plant');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/schedule');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/library');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: const Color(0xFF59D46E),
      unselectedItemColor: Colors.grey.shade500,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: "Add"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
        BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined), label: "Library"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
