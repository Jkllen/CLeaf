import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // === GREEN HEADER ===
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 20), // include top padding for status bar
            color: Colors.green,
            child: Text(
              "Home Dashboard",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // === BODY ===
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // === TITLE & SUBTEXT ===
                    Text(
                      "Getting Started!",
                      style: GoogleFonts.inriaSerif(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Keep your green friends happy and healthy",
                      style: GoogleFonts.inriaSerif(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // === ADD NEW PLANT BUTTON ===
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/main', arguments: 1);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF59D46E),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_circle, color: Colors.white, size: 26),
                            const SizedBox(width: 8),
                            Text(
                              "Add New Plant",
                              style: GoogleFonts.inriaSerif(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // === UPCOMING TASKS ===
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Upcoming Tasks",
                        style: GoogleFonts.inriaSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const UpcomingTasksSection(),

                    const SizedBox(height: 32),

                    // === MY PLANTS ===
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Plants",
                        style: GoogleFonts.inriaSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const MyPlantsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
