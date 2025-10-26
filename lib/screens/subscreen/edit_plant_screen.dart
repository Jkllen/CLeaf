import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cleaf/services/plant_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPlantScreen extends StatefulWidget {
  final Map<String, dynamic> plantData;
  const EditPlantScreen({super.key, required this.plantData});

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  // controllers
  late TextEditingController _nicknameController;
  late TextEditingController _notesController;
  late TextEditingController _lastWateredController;
  late TextEditingController _wateringFreqController;
  late TextEditingController _fertilizingFreqController;

  String? _selectedSpecies;
  bool _notificationsEnabled = false;
  File? _newImage;
  bool _isSaving = false;
  bool _isDeleting = false;

  int _wateringFrequency = 7;
  int _fertilizingFrequency = 30;

  final List<String> _speciesOptions = [
    'Aloe Vera',
    'Snake Plant',
    'Peace Lily',
    'Spider Plant',
    'Money Tree',
    'Pothos',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.plantData;

    _nicknameController = TextEditingController(text: p['nickname'] ?? '');
    _notesController = TextEditingController(text: p['careNotes'] ?? '');
    _selectedSpecies = p['species'] ?? _speciesOptions.last;

    // lastWatered may be Date or ISO string — normalize to ISO if present
    if (p['lastWatered'] != null) {
      try {
        final dt = DateTime.parse(p['lastWatered'].toString());
        _lastWateredController = TextEditingController(
          text: dt.toIso8601String(),
        );
      } catch (_) {
        _lastWateredController = TextEditingController(
          text: p['lastWatered'].toString(),
        );
      }
    } else {
      _lastWateredController = TextEditingController();
    }

    _wateringFrequency = (p['wateringFrequency'] is int)
        ? p['wateringFrequency']
        : int.tryParse(p['wateringFrequency']?.toString() ?? '') ?? 7;
    _fertilizingFrequency = (p['fertilizingFrequency'] is int)
        ? p['fertilizingFrequency']
        : int.tryParse(p['fertilizingFrequency']?.toString() ?? '') ?? 30;

    _wateringFreqController = TextEditingController(
      text: '$_wateringFrequency',
    );
    _fertilizingFreqController = TextEditingController(
      text: '$_fertilizingFrequency',
    );

    _notificationsEnabled =
        p['notificationsEnabled'] ?? p['notifications'] ?? false;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _notesController.dispose();
    _lastWateredController.dispose();
    _wateringFreqController.dispose();
    _fertilizingFreqController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                final f = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                Navigator.pop(context, f);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                final f = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                Navigator.pop(context, f);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context, null),
            ),
          ],
        ),
      ),
    );

    if (picked != null) {
      setState(() => _newImage = File(picked.path));
    }
  }

  Future<void> _pickLastWateredDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastWateredController.text.isNotEmpty
          ? DateTime.tryParse(_lastWateredController.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _lastWateredController.text = picked.toIso8601String();
      });
    }
  }

  Future<void> _pickWateringFrequency() async {
    final value = await showDialog<int>(
      context: context,
      builder: (_) => NumberPickerDialog(
        title: 'Watering Frequency (days)',
        initialValue: _wateringFrequency,
      ),
    );
    if (value != null) {
      setState(() {
        _wateringFrequency = value;
        _wateringFreqController.text = '$_wateringFrequency';
      });
    }
  }

  Future<void> _pickFertilizingFrequency() async {
    final value = await showDialog<int>(
      context: context,
      builder: (_) => NumberPickerDialog(
        title: 'Fertilizing Frequency (days)',
        initialValue: _fertilizingFrequency,
      ),
    );
    if (value != null) {
      setState(() {
        _fertilizingFrequency = value;
        _fertilizingFreqController.text = '$_fertilizingFrequency';
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final updatedPlant = {
      '_id': widget.plantData['_id'],
      'nickname': _nicknameController.text.trim(),
      'species': _selectedSpecies,
      'careNotes': _notesController.text.trim(),
      'lastWatered': _lastWateredController.text.isNotEmpty
          ? _lastWateredController.text
          : null,
      'wateringFrequency': _wateringFrequency,
      'fertilizingFrequency': _fertilizingFrequency,
      'notificationsEnabled': _notificationsEnabled,
    };

    final success = await PlantService.updatePlant(
      token,
      widget.plantData['_id'],
      updatedPlant,
      imageFile: _newImage,
    );

    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant updated successfully 🌿')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update plant')));
    }
  }

  Future<void> _deletePlant() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Plant'),
        content: const Text(
          'Are you sure you want to delete this plant? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isDeleting = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final success = await PlantService.deletePlant(
      token,
      widget.plantData['_id'],
    );
    setState(() => _isDeleting = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Plant deleted')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete plant')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingImageUrl = widget.plantData['imageUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.plantData['nickname'] ?? 'Edit Plant',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deletePlant,
          ),
        ],
      ),
      body: _isSaving || _isDeleting
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _newImage != null
                              ? Image.file(
                                  _newImage!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : (existingImageUrl != null &&
                                    existingImageUrl.isNotEmpty)
                              ? Image.network(
                                  existingImageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 60),
                                ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload),
                          label: const Text('Upload New Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nickname
                  TextField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                      labelText: 'Plant Nickname',
                      prefixIcon: Icon(
                        Icons.local_florist,
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Species dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Species',
                      prefixIcon: Icon(
                        Icons.grass,
                        color: Colors.green,
                        size: 30,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSpecies,
                    items: _speciesOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() => _selectedSpecies = newValue);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Last Watered (read only, opens date picker)
                  TextField(
                    readOnly: true,
                    controller: _lastWateredController,
                    onTap: _pickLastWateredDate,
                    decoration: const InputDecoration(
                      labelText: 'Last Watered',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Watering frequency (picker)
                  TextField(
                    readOnly: true,
                    controller: _wateringFreqController
                      ..text = '$_wateringFrequency',
                    decoration: const InputDecoration(
                      labelText: 'Watering Frequency (days)',
                      prefixIcon: Icon(
                        Icons.water_drop,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                    ),
                    onTap: _pickWateringFrequency,
                  ),

                  const SizedBox(height: 20),

                  // Fertilizing frequency (picker)
                  TextField(
                    readOnly: true,
                    controller: _fertilizingFreqController
                      ..text = '$_fertilizingFrequency',
                    decoration: const InputDecoration(
                      labelText: 'Fertilizing Frequency (days)',
                      prefixIcon: Icon(
                        Icons.local_dining,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                    onTap: _pickFertilizingFrequency,
                  ),

                  const SizedBox(height: 20),

                  // Care notes
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Care Notes',
                      prefixIcon: Icon(
                        Icons.notes,
                        color: Colors.brown,
                        size: 30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Notifications
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications,
                        color: Colors.purple,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Enable Notifications',
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) =>
                            setState(() => _notificationsEnabled = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

// NumberPickerDialog
class NumberPickerDialog extends StatefulWidget {
  final String title;
  final int initialValue;
  const NumberPickerDialog({
    required this.title,
    required this.initialValue,
    super.key,
  });

  @override
  State<NumberPickerDialog> createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<NumberPickerDialog> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            Slider(
              value: _value.toDouble(),
              min: 1,
              max: 365,
              divisions: 29,
              label: '$_value days',
              onChanged: (v) => setState(() => _value = v.toInt()),
            ),
            Text('$_value days'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _value),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
