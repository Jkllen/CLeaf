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
    final url = Uri.parse('$baseUrl/addedPlants');
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
        return data['plants'] ?? [];
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
    String token,
    Map<String, dynamic> plantData, {
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/addedPlants');
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
        final mimeType =
            lookupMimeType(imageFile.path)?.split('/') ?? ['image', 'jpeg'];
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

  // ======= UPDATE PLANT INFORMATION CATALOG =======
  static Future<bool> updatePlant(String token, String plantId, Map<String, dynamic> plantData, {File? imageFile}) async {
    final uri = Uri.parse('$baseUrl/addedPlants/$plantId');
    try {
      if (imageFile != null) {
        final request = http.MultipartRequest('PUT', uri);
        request.headers['Authorization'] = 'Bearer $token';

        plantData.forEach((key, value) {
          if (value != null) request.fields[key] = value.toString();
        });

        // Add the image file
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

        final streamed = await request.send();
        final response = await http.Response.fromStream(streamed);
        return response.statusCode == 200;
      } else {
        final response = await http.put(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(plantData),
        );
        return response.statusCode == 200;
      }
    } catch (e) {
      print('updatePlant exception: $e');
      return false;
    }
  }

  // DELETE plant
  static Future<bool> deletePlant(String token, String plantId) async {
    final uri = Uri.parse('$baseUrl/addedPlants/$plantId');
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('deletePlant exception: $e');
      return false;
    }
  }
}