import 'package:cleaf/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cleaf/screens/splash_screen.dart';
import 'package:cleaf/screens/add_plant_screen.dart';
import 'package:cleaf/screens/library_screen.dart';
import 'package:cleaf/screens/profile_screen.dart';
import 'package:cleaf/screens/schedule_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryGreen = Color (0xFF59D46E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CLeaf',
      theme: ThemeData(
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryGreen,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        )
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-plant': (context) => const AddPlantScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/library': (context) => const LibraryScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}