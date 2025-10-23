import 'package:flutter/material.dart';
import 'package:cleaf/screens/home_screen.dart';
import 'package:cleaf/screens/add_plant_screen.dart';
import 'package:cleaf/screens/schedule_screen.dart';
import 'package:cleaf/screens/library_screen.dart';
import 'package:cleaf/screens/profile_screen.dart';
import 'package:cleaf/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AddPlantScreen(),
    ScheduleScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Can't access ModalRoute here; use addPostFrameCallback to read arguments once the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int && args >= 0 && args < _screens.length) {
        setState(() {
          _selectedIndex = args;
        });
      }
    });
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CLeafBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
