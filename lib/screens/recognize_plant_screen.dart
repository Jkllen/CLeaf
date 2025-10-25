import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cleaf/utils/plant_recognizer.dart';

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

  Future<void> _detectPlant() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await PlantRecognizer.recognizePlantFromFile(_selectedImage!);
      print("Raw Roboflow Result: $result");

      // Extract base64 visualization (if available)
      String? base64Vis;
      try {
        final outputImage = result["output_image"];
        if (outputImage != null && outputImage["type"] == "base64") {
          base64Vis = outputImage["value"] as String?;
        }
      } catch (_) {
        base64Vis = null;
      }

      // Extract predictions (if available)
      final predictionsList = (result["predictions"] as List?)
              ?.map((p) => {
                    "class": p["class"],
                    "confidence": p["confidence"],
                  })
              .toList()
              .cast<Map<String, dynamic>>() ??
          [];

      setState(() {
        _base64Image = base64Vis;
        _predictions = predictionsList;
      });
    } catch (e) {
      print('Detection error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to detect plant')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (_base64Image != null) {
      imageBytes = base64Decode(_base64Image!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recognize Plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_selectedImage!, height: 200),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _detectPlant,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Detect Plant'),
              ),
              const SizedBox(height: 20),
              if (imageBytes != null)
                Column(
                  children: [
                    const Text(
                      "Detection Visualization:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(imageBytes, height: 250),
                    ),
                  ],
                ),
              if (_predictions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Detected Plants:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ..._predictions.map((p) => ListTile(
                          leading: const Icon(Icons.local_florist),
                          title: Text(p["class"]),
                          subtitle: Text(
                            "Confidence: ${(p["confidence"] * 100).toStringAsFixed(1)}%",
                          ),
                        )),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
