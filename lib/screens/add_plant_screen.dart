import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/add_plant_widgets.dart';
import 'package:cleaf/screens/recognize_plant_screen.dart';
import 'package:cleaf/screens/manual_add_plant_screen.dart';

class AddPlantScreen extends StatelessWidget {
  final VoidCallback onClose; // callback to close overlay

  const AddPlantScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with Close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // placeholder for alignment
                  Text(
                    "Add New Plant",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Choose how you want to add your plant.",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Option 1: Recognize with Photo
                    PlantOptionCard(
                      color: const Color(0xFF56D36B),
                      title: "Recognize Plant with Photo",
                      subtitle: "Use your camera to capture your plant",
                      icon: Icons.camera_alt_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecognizePlantScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Option 2: Manually Add
                    PlantOptionCard(
                      color: const Color(0xFFF0A276),
                      title: "Manually Add Plant",
                      subtitle: "Input plant manually",
                      icon: Icons.edit_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManualAddPlantScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
