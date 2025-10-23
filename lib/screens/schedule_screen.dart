import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Schedule",
                style: GoogleFonts.openSans(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Here you can view and manage your plant care schedules.",
                style: GoogleFonts.inriaSerif(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              // TODO: Add your schedule widgets or UI here
              Center(
                child: Text(
                  "No schedules yet.",
                  style: GoogleFonts.inriaSerif(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
