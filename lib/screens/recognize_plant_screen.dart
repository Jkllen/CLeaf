import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cleaf/utils/plant_recognizer.dart';
import 'manual_add_plant_screen.dart';
import '../utils/constants.dart';

class RecognizePlantScreen extends StatefulWidget {
  const RecognizePlantScreen({super.key});

  @override
  State<RecognizePlantScreen> createState() => _RecognizePlantScreenState();
}

class _RecognizePlantScreenState extends State<RecognizePlantScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  List<Map<String, dynamic>> _predictions = [];
  String? _base64Image;

  /// Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _predictions = [];
        _base64Image = null;
      });
    }
  }

  /// Detect plant using backend + Roboflow
  Future<void> _detectPlant() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await PlantRecognizer.recognizePlantFromFile(
        _selectedImage!,
      );
      print("Raw Roboflow Result: $result");

      final outputs = result["outputs"] as List?;
      if (outputs == null || outputs.isEmpty)
        throw Exception("No outputs from Roboflow");

      final firstOutput = outputs[0];

      // Extract Base64 visualization if exists
      String? base64Vis;
      try {
        final outputImage = firstOutput["output_image"];
        if (outputImage != null && outputImage["type"] == "base64") {
          base64Vis = outputImage["value"] as String?;
        }
      } catch (_) {
        base64Vis = null;
      }

      // Extract predictions safely
      final predictionsData = firstOutput["predictions"];
      final predictionsList =
          (predictionsData != null && predictionsData["predictions"] != null)
          ? (predictionsData["predictions"] as List)
                .map(
                  (p) => {
                    "class": p["class"],
                    "confidence": p["confidence"],
                    "scientificName": p["scientificName"] ?? "",
                  },
                )
                .toList()
                .cast<Map<String, dynamic>>()
          : <Map<String, dynamic>>[];

      setState(() {
        _base64Image = base64Vis;
        _predictions = predictionsList;
      });
    } catch (e) {
      print('Detection error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to detect plant')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Helper to build camera/gallery buttons
  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(fontSize: 15, color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (_base64Image != null) {
      imageBytes = base64Decode(_base64Image!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recognize Plant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image container
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFFEEEEEE),
                padding: const EdgeInsets.all(16),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Camera & Gallery buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.camera_alt,
                  "Camera",
                  () => _pickImage(ImageSource.camera),
                ),
                _buildActionButton(
                  Icons.photo_library,
                  "Gallery",
                  () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Detect button
            ElevatedButton(
              onPressed: _isLoading ? null : _detectPlant,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Detect Plant"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            Container(
              width: double.infinity,
              height: 2,
              color: const Color(0xFFD9D9D9),
              margin: const EdgeInsets.symmetric(vertical: 20),
            ),

            // Detection visualization
            if (imageBytes != null)
              Column(
                children: [
                  const Text(
                    "Detection Visualization:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      imageBytes,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

            //Predictions list
            if (_predictions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _predictions.map((p) {
                  final confidence = (p["confidence"] * 100).toStringAsFixed(0);
                  return GestureDetector(
                    onTap: () {
                      final species = p["class"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ManualAddPlantScreen(
                            prefilledSpecies: species,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              p["class"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB1FFC0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Text(
                              "$confidence% match",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF008B17),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
