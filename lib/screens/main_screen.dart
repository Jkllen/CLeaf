import 'package:flutter/material.dart';
import 'package:cleaf/screens/home_screen.dart';
import 'package:cleaf/screens/schedule_screen.dart';
import 'package:cleaf/screens/library_screen.dart';
import 'package:cleaf/screens/profile_screen.dart';
import 'package:cleaf/screens/catalog_screen.dart';
import 'package:cleaf/screens/add_plant_screen.dart';
import 'package:cleaf/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Overlay screen for AddPlantScreen
  Widget? _overlayScreen;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onAddPlantPressed: _showAddPlantScreen,
      ),
      CatalogScreen(
        onAddPlantPressed: _showAddPlantScreen, // pass callback to FAB
      ),
      ScheduleScreen(
        goToCatalog: () => _onItemTapped(1), // Catalog tab index
      ),
      const LibraryScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _overlayScreen = null; // close overlay if switching tabs
    });
  }

  void _showAddPlantScreen() {
    setState(() {
      _overlayScreen = AddPlantScreen(
        onClose: _closeOverlay,
      );
    });
  }

  void _closeOverlay() {
    setState(() {
      _overlayScreen = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          if (_overlayScreen != null)
            Positioned.fill(
              child: Material(
                color: Colors.white,
                child: SafeArea(child: _overlayScreen!),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CLeafBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
