import 'package:flutter/material.dart';
import '../services/plant_service.dart';
import 'package:cleaf/screens/subscreen/edit_plant_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CatalogScreen extends StatefulWidget {
  final VoidCallback? onAddPlantPressed;

  const CatalogScreen({super.key, this.onAddPlantPressed});

  @override
  State<CatalogScreen> createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  List<dynamic> _plants = [];

  @override
  void initState() {
    super.initState();
    _fetchUserPlants();
  }

  Future<void> _fetchUserPlants() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final plants = await PlantService.fetchUserPlants(token);

    setState(() {
      _plants = plants;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlants = _plants.where((plant) {
      final name = (plant['nickname'] ?? '').toString().toLowerCase();
      final species = (plant['species'] ?? '').toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || species.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Plant Catalog',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 🔍 Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search plants...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 🌿 Plant List
          _isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              : Expanded(
                  child: filteredPlants.isEmpty
                      ? const Center(
                          child: Text(
                            'No plants added yet 🌱',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredPlants.length,
                          itemBuilder: (context, index) {
                            final plant = filteredPlants[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditPlantScreen(plantData: plant),
                                    ),
                                  );
                                  _fetchUserPlants(); // refresh when returning
                                },
                                child: ListTile(
                                  leading:
                                      (plant['imageUrl'] != null &&
                                          plant['imageUrl'].isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            plant['imageUrl'],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 40,
                                                    ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.local_florist,
                                          size: 40,
                                          color: Colors.green,
                                        ),
                                  title: Text(
                                    plant['nickname'] ?? 'Unnamed',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Species: ${plant['species'] ?? "Unknown"}\n'
                                    'Water every ${plant['wateringFrequency'] ?? "-"} days\n'
                                    'Fertilize every ${plant['fertilizingFrequency'] ?? "-"} days\n'
                                    'Care Notes: ${plant['careNotes'] ?? "None"}',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            widget.onAddPlantPressed, // use callback instead of Navigator.push
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
