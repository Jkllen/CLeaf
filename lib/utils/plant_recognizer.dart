import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlantRecognizer {
  static const String _baseUrl = 'https://cleaf-backend.onrender.com/api/roboflow/detect';

  // Sends image to backend (Render) which calls Roboflow.
  // imageUrl is a public URL
  static Future<Map<String, dynamic>> recognizePlantFromUrl(String imageUrl) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imageUrl': imageUrl}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to detect plant: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> recognizePlantFromFile(File imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to detect plant: ${response.body}');
    }
  }
}
