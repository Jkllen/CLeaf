import 'dart:convert';
import 'package:http/http.dart' as http;

// Note: If using Android emulator, replace "localhost" with 10.0.2.2
// Note: If same machine localhost / 127.0.0.1 for same machine
// Note: if Physical Phone via Usb, needs Current IPv4
class AuthService {
  static const String baseUrl = 'https://cleaf-backend.onrender.com/api/auth';

  // Signup function
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      }),
    );

    return jsonDecode(response.body);
  }

  // Login function
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // Forgot Password
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    return jsonDecode(response.body);
  }

  // Reset Password
  static Future<Map<String, dynamic>> resetPassword({
    required String userId,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/reset-password');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "token": token,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      }),
    );

    return jsonDecode(response.body);
  }
}
