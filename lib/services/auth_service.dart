import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  // Login function (with token save)
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    print("Login attempt with username: $username");

    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    try {
      final data = jsonDecode(response.body);
      print("✅ [LOGIN] Parsed JSON: $data");

      if (response.statusCode == 200 && data['token'] != null) {
        print("🔑 [LOGIN] JWT Token: ${data['token']}");

        // ✅ Save token to SharedPreferences for future use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('username', data['user']['username']);
      } else {
        print("⚠️ [LOGIN] No token found or invalid status!");
      }

      return data;
    } catch (e) {
      print("[LOGIN] JSON decode failed: $e");
      return {"success": false, "message": "Invalid response format"};
    }
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

  // 🧩 Get stored JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 🚪 Logout and clear saved data
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
  }

    // Fetch user profile (Protected route)
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    if (token == null) {
      return {"success": false, "message": "No token found"};
    }

    final url = Uri.parse('$baseUrl/profile');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("🔍 [PROFILE] Response status: ${response.statusCode}");
    print("📦 [PROFILE] Raw body: ${response.body}");

    try {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "user": data["user"]};
      } else {
        return {"success": false, "message": data["message"] ?? "Failed to fetch profile"};
      }
    } catch (e) {
      print("[PROFILE] JSON decode error: $e");
      return {"success": false, "message": "Invalid server response"};
    }
  }
}
