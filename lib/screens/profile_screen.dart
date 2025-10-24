import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/profile_widgets.dart';
import 'package:cleaf/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print('SharedPreferences token: ${token == null ? "null" : "FOUND"}');

      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
          userData = null;
        });
        return;
      }

      final data = await ApiService.getUserProfile(token);

      setState(() {
        userData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('fetchProfile() exception: $e');
      setState(() {
        _isLoading = false;
        userData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    if (userData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        body: Center(
          child: Text(
            'Failed to load profile.',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userData!['firstName']} ${userData!['lastName']}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      userData!['email'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.check_circle : Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Profile fields
            ProfileInfoField(
              label: 'First Name',
              value: userData!['firstName'],
              isEditing: _isEditing,
              onChanged: (val) => userData!['firstName'] = val,
            ),
            ProfileInfoField(
              label: 'Last Name',
              value: userData!['lastName'],
              isEditing: _isEditing,
              onChanged: (val) => userData!['lastName'] = val,
            ),
            ProfileInfoField(
              label: 'Email',
              value: userData!['email'],
              isEditing: _isEditing,
              onChanged: (val) => userData!['email'] = val,
            ),
            ProfileInfoField(
              label: 'Username',
              value: userData!['username'],
              isEditing: _isEditing,
              onChanged: (val) => userData!['username'] = val,
            ),
          ],
        ),
      ),
    );
  }
}