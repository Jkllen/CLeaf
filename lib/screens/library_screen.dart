import 'package:flutter/material.dart';
import '../services/plant_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cleaf/screens/subscreen/plant_detail.dart';
import 'package:shimmer/shimmer.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _isLoading = true;
  List<dynamic> _plants = [];
  List<dynamic> _filteredPlants = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPlants();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchPlants() async {
    try {
      final plants = await PlantService.fetchLibraryPlants();
      setState(() {
        _plants = plants;
        _filteredPlants = plants;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch library plants: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlants = _plants.where((plant) {
        final name = plant['nickname']?.toLowerCase() ?? '';
        final scientific = plant['scientificName']?.toLowerCase() ?? '';
        return name.contains(query) || scientific.contains(query);
      }).toList();
    });
  }

  void _openPlantDetail(dynamic plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlantDetailScreen(
          name: plant['nickname'] ?? '-',
          scientificName: plant['scientificName'] ?? '-',
          imageUrl: plant['imageUrl'] ?? '',
          light: plant['light'] ?? '-',
          wateringFrequency: plant['wateringFrequency'] ?? '-',
          temperature: plant['temperature'] ?? '-',
          careTips: plant['careTips'] ?? '-',
          definition: plant['definition'] ?? '-',
          water: plant['waterAmount'] ?? '-',
          info: plant['description'] ?? '-',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Care Library',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // 🔍 Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search plants...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🌿 Plant Grid
                  Expanded(
                    child: _filteredPlants.isEmpty
                        ? const Center(
                            child: Text(
                              'No plants found.',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _filteredPlants.length,
                            itemBuilder: (context, index) {
                              final plant = _filteredPlants[index];
                              return GestureDetector(
                                onTap: () => _openPlantDetail(plant),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(2, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // 🌿 Image
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          child: Image.network(
                                            plant['imageUrl'] ?? '',
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                child: Container(
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                              Icons.error,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 🌿 Name
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          plant['nickname'] ?? '-',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
