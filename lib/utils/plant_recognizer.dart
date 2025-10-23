import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PlantRecognizer {
  late Interpreter _interpreter;
  final int inputSize = 416;

  final List<String> labels = [
    "Snake Plant",
    // Add more if you train more classes
  ];

  /// Load YOLOv8 model
  Future<void> loadModel() async {
    try {
      print('🔄 [PlantRecognizer] Loading model...');
      _interpreter = await Interpreter.fromAsset('assets/model/best_float32.tflite');
      print('✅ Model loaded successfully!');
      print('📏 Input tensor shape: ${_interpreter.getInputTensor(0).shape}');
      print('📏 Output tensor shape: ${_interpreter.getOutputTensor(0).shape}');
    } catch (e, stack) {
      print('❌ Failed to load model: $e');
      print('🧩 Stack trace: $stack');
    }
  }

  /// Recognize a plant image and return detection info
  Future<Map<String, dynamic>> recognizePlant(File imageFile) async {
    try {
      print('🔥 [PlantRecognizer] recognizePlant() called with image: ${imageFile.path}');
      if (!await imageFile.exists()) {
        return {'label': 'Error', 'confidence': 0.0, 'boxes': []};
      }

      // 1️⃣ Decode and resize
      final imageBytes = await imageFile.readAsBytes();
      final decoded = img.decodeImage(imageBytes);
      if (decoded == null) return {'label': 'Decode error', 'confidence': 0.0, 'boxes': []};

      print('📏 Original image: ${decoded.width}x${decoded.height}');
      final resized = img.copyResize(decoded, width: inputSize, height: inputSize);
      print('📐 Resized to: ${resized.width}x${resized.height}');

      // 2️⃣ Convert to Float32
      final input = imageToFloat32List(resized, inputSize);
      print('✅ Converted to Float32List (length: ${input.length})');

      // 3️⃣ Prepare output
      final outputShape = _interpreter.getOutputTensor(0).shape;
      final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0).reshape(outputShape);

      print('🧠 Running inference...');
      _interpreter.run(input.reshape([1, inputSize, inputSize, 3]), output);
      print('✅ Inference complete!');

      // 4️⃣ Parse detections
      final detections = _parseYoloOutput(output);

      if (detections.isEmpty) {
        print('⚠️ No detections found.');
        return {'label': 'No plant detected', 'confidence': 0.0, 'boxes': []};
      }

      // 5️⃣ Find best detection
      final best = detections.reduce((a, b) => a['confidence'] > b['confidence'] ? a : b);
      final label = labels[best['classId']];
      final conf = best['confidence'];

      print('✅ Best match: $label (${(conf * 100).toStringAsFixed(1)}%)');
      return {'label': label, 'confidence': conf, 'boxes': detections};
    } catch (e, stack) {
      print('❌ Recognition failed: $e');
      print('🧩 Stack trace: $stack');
      return {'label': 'Error', 'confidence': 0.0, 'boxes': []};
    }
  }

  /// Convert image to Float32 tensor
  Float32List imageToFloat32List(img.Image image, int size) {
    final convertedBytes = Float32List(1 * size * size * 3);
    int pixelIndex = 0;

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final pixel = image.getPixel(x, y);
        convertedBytes[pixelIndex++] = pixel.r / 255.0;
        convertedBytes[pixelIndex++] = pixel.g / 255.0;
        convertedBytes[pixelIndex++] = pixel.b / 255.0;
      }
    }
    return convertedBytes;
  }

  /// Parse YOLOv8 TFLite output and normalize coordinates
  List<Map<String, dynamic>> _parseYoloOutput(dynamic output) {
    final List<Map<String, dynamic>> detections = [];

    if (output is List) {
      final nested = output.expand((e) => e is List ? e : [e]).toList();

      for (var det in nested) {
        if (det is List && det.length >= 6) {
          final x = det[0] / inputSize; // normalize
          final y = det[1] / inputSize;
          final w = det[2] / inputSize;
          final h = det[3] / inputSize;
          final confidence = det[4];
          final classId = det[5].toInt();

          if (confidence > 0.10) {
            detections.add({
              'x': x - w / 2,
              'y': y - h / 2,
              'w': w,
              'h': h,
              'confidence': confidence,
              'classId': classId,
            });
            print('🎯 Detection -> class: $classId, confidence: $confidence');
          }
        }
      }
    } else {
      print("⚠️ Unexpected output format: ${output.runtimeType}");
    }

    return detections;
  }
}
