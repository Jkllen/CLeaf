import 'package:flutter/material.dart';
import 'package:cleaf/screens/splash_screen.dart';
import 'package:cleaf/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryGreen = Color(0xFF59D46E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CLeaf',
      theme: ThemeData(
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen),
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
