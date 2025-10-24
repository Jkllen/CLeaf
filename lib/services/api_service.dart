import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://cleaf-backend.onrender.com/api/auth';

  static Future<Map<String, dynamic>?> getUserProfile(String token) async {
    final url = Uri.parse(
      '$baseUrl/profile',
    ); 
    print('Requesting profile from: $url');
    print(
      'Token (first 10 chars): ${token?.substring(0, token.length >= 10 ? 10 : token.length)}',
    );
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Profile API Status: ${response.statusCode}');
      print('Profile API Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['user'];
      } else {
        print('Profile API returned error: ${response.body}');
        return null;
      }
    } catch (e) {
      print("Profile API Exception: $e");
      return null;
    }
  }
}
