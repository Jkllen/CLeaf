import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/widgets/profile_widgets.dart';
import 'package:cleaf/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cleaf/screens/auth/login_screen.dart';

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
      setState(() {
        _isLoading = false;
        userData = null;
      });
    }
  }

  // -------------------- LOGOUT FUNCTION --------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear token & username
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0x0fffffff),
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    if (userData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFECECEC),
        body: Center(
          child: Text(
            'Failed to load profile.',
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // -------------------- HEADER --------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF68BE68),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
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
                    onPressed: () async {
                      if (_isEditing) {
                        // Save logic
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');
                        if (token != null) {
                          final result =
                              await ApiService.updateUserProfile(token, {
                                'firstName': userData!['firstName'],
                                'lastName': userData!['lastName'],
                                'email': userData!['email'],
                                'username': userData!['username'],
                              });

                          if (result['success'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result['message'] ?? 'Update failed',
                                ),
                              ),
                            );
                          }
                        }
                      }

                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                  ),
                ],
              ),
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

            const SizedBox(height: 40),

            // -------------------- LOGOUT BUTTON --------------------
            GestureDetector(
              onTap: logout,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF31FFB7),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D0601B4),
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
