import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                "Profile",
                style: GoogleFonts.openSans(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Manage your account and preferences.",
                style: GoogleFonts.inriaSerif(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              // TODO: Replace this with user profile details or settings
              Center(
                child: Text(
                  "No user data available.",
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
