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
  final PlantRecognizer recognizer = PlantRecognizer();
  File? _image;
  String _result = '';
  List<Map<String, dynamic>> _boxes = [];

  @override
  void initState() {
    super.initState();
    recognizer.loadModel();
  }

  Future<void> _captureOrPickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    setState(() {
      _image = file;
      _result = 'Analyzing...';
      _boxes = [];
    });

    final result = await recognizer.recognizePlant(file);
    setState(() {
      _result =
          "Detected: ${result['label']} (Confidence: ${(result['confidence'] * 100).toStringAsFixed(1)}%)";
      _boxes = result['boxes'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recognize Plant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image != null)
              Stack(
                children: [
                  Image.file(_image!, height: 250, fit: BoxFit.cover),
                  if (_boxes.isNotEmpty)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BoundingBoxPainter(_boxes),
                      ),
                    ),
                ],
              )
            else
              const SizedBox(
                height: 250,
                child: Center(child: Text('No image selected')),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  onPressed: () => _captureOrPickImage(ImageSource.camera),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  onPressed: () => _captureOrPickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

/// Painter to draw bounding boxes
class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> boxes;
  BoundingBoxPainter(this.boxes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(180, 0, 255, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var box in boxes) {
      final rect = Rect.fromLTWH(
        box['x'] * size.width,
        box['y'] * size.height,
        box['w'] * size.width,
        box['h'] * size.height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
