import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/add_plant_widgets.dart';
import 'package:cleaf/screens/recognize_plant_screen.dart';
import 'package:cleaf/screens/manual_add_plant_screen.dart';
import 'package:cleaf/screens/upload_plant_screen.dart';

class AddPlantScreen extends StatelessWidget {
  const AddPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Add New Plant",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Choose how you want to add your plant.",
                style: GoogleFonts.poppins(
                  fontSize: 20,
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
              const SizedBox(height: 20),

              // Option 3: Upload from Device
              PlantOptionCard(
                color: const Color(0xFFA1A1A1),
                title: "Upload Image",
                subtitle: "Select an image from your device",
                icon: Icons.image_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UploadPlantScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
