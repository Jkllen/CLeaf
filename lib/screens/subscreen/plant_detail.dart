import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantDetailScreen extends StatelessWidget {
  final String name;
  final String scientificName;
  final String imageUrl;
  final String light;
  final String wateringFrequency;
  final String temperature;
  final String careTips;
  final String definition;
  final String water;
  final String info;

  const PlantDetailScreen({
    super.key,
    required this.name,
    required this.scientificName,
    required this.imageUrl,
    required this.light,
    required this.wateringFrequency,
    required this.temperature,
    required this.careTips,
    required this.definition,
    required this.water,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, 
          style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          ),),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.greenAccent.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🌿 Plant Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🌿 Info Panel
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name & Scientific Name
                      Text(
                        name,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        scientificName,
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                      const SizedBox(height: 15),

                      // Definition
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          definition,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🌿 Info Cards (2x2)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildInfoCard(Icons.water_drop, 'Water', water, Colors.blueAccent),
                          _buildInfoCard(Icons.calendar_today, 'Frequency', wateringFrequency, Colors.teal),
                          _buildInfoCard(Icons.wb_sunny, 'Light', light, Colors.orangeAccent),
                          _buildInfoCard(Icons.thermostat, 'Temperature', temperature, Colors.deepOrange),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      _buildSection('📕 Description', info),

                      const SizedBox(height: 15),

                      // Care Tips
                      _buildSection('🪴 Care Tips', careTips),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color iconColor) {
    return Container(
      width: 150,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4, offset: const Offset(2, 3))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(value, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(content, style: const TextStyle(fontSize: 16), textAlign: TextAlign.justify),
      ],
    );
  }
}
