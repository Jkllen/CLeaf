import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PlantService {
  static const String baseUrl = 'https://cleaf-backend.onrender.com/api/plants';

  // ======= FETCH ALL LIBRARY PLANTS =======
  static Future<List<dynamic>> fetchLibraryPlants() async {
    final url = Uri.parse('$baseUrl/library');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Library fetch: $data');
        return data['plants'] ?? [];
      } else {
        print('Library API error: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Library API exception: $e');
      return [];
    }
  }

  // ======= FETCH USER PLANTS =======
  static Future<List<dynamic>> fetchUserPlants(String token) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // backend returns array directly
      } else {
        print('User plants API error: ${response.body}');
        return [];
      }
    } catch (e) {
      print('User plants API exception: $e');
      return [];
    }
  }

  // ======= ADD NEW PLANT (optional image) =======
  static Future<Map<String, dynamic>> addPlant(
      String token, Map<String, dynamic> plantData,
      {File? imageFile}) async {
    final uri = Uri.parse(baseUrl);
    try {
      // Use MultipartRequest if image is provided
      if (imageFile != null) {
        final request = http.MultipartRequest('POST', uri);
        request.headers['Authorization'] = 'Bearer $token';

        // Add text fields
        plantData.forEach((key, value) {
          if (value != null) request.fields[key] = value.toString();
        });

        // Add image file
        final mimeType = lookupMimeType(imageFile.path)?.split('/') ?? ['image', 'jpeg'];
        final fileStream = http.ByteStream(imageFile.openRead());
        final fileLength = await imageFile.length();
        final multipartFile = http.MultipartFile(
          'image',
          fileStream,
          fileLength,
          filename: imageFile.path.split('/').last,
          contentType: MediaType(mimeType[0], mimeType[1]),
        );
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          print('Add plant API error: ${response.body}');
          return {'success': false, 'message': 'Failed to add plant'};
        }
      } else {
        // No image: send JSON
        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(plantData),
        );

        if (response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          print('Add plant API error: ${response.body}');
          return {'success': false, 'message': 'Failed to add plant'};
        }
      }
    } catch (e) {
      print('Add plant exception: $e');
      return {'success': false, 'message': 'Exception occurred'};
    }
  }
}
