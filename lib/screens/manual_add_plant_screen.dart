import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/plant_service.dart';

class ManualAddPlantScreen extends StatefulWidget {
  const ManualAddPlantScreen({super.key});

  @override
  State<ManualAddPlantScreen> createState() => _ManualAddPlantScreenState();
}

class _ManualAddPlantScreenState extends State<ManualAddPlantScreen> {
  final ScrollController _scrollbar = ScrollController();

  // Form controllers
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _wateringFreqController = TextEditingController();
  final TextEditingController _fertilizingFreqController = TextEditingController();
  final TextEditingController _lastWateredController = TextEditingController();
  final TextEditingController _careNotesController = TextEditingController();

  String? _selectedSpecies = 'Select Species';
  bool _notificationsEnabled = false;
  File? _selectedImage;

  int _wateringFrequency = 7; // default days
  int _fertilizingFrequency = 30; // default days
  bool _isSaving = false;

  @override
  void dispose() {
    _scrollbar.dispose();
    _nicknameController.dispose();
    _speciesController.dispose();
    _wateringFreqController.dispose();
    _fertilizingFreqController.dispose();
    _lastWateredController.dispose();
    _careNotesController.dispose();
    super.dispose();
  }

  // Pick plant image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick last watered date
  Future<void> _pickLastWateredDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _lastWateredController.text = picked.toIso8601String();
      });
    }
  }

  // Save plant to backend
  Future<void> _savePlant() async {
    if (_nicknameController.text.isEmpty || _speciesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide nickname and species')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final plantData = {
      'nickname': _nicknameController.text,
      'species': _speciesController.text,
      'wateringFrequency': _wateringFrequency,
      'fertilizingFrequency': _fertilizingFrequency,
      'lastWatered': _lastWateredController.text.isNotEmpty ? _lastWateredController.text : null,
      'careNotes': _careNotesController.text,
      'notificationsEnabled': _notificationsEnabled,
    };

    final result = await PlantService.addPlant(token, plantData, imageFile: _selectedImage);

    setState(() => _isSaving = false);

    if (result['success'] == false || result['message'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to add plant')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plant added successfully!')),
    );

    Navigator.pop(context, true); // indicate a new plant was added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Add New Plant',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Scrollbar(
        controller: _scrollbar,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollbar,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(_selectedImage!,
                                    width: 150, height: 150, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.photo, size: 60, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          _selectedImage != null ? "Tap to change photo" : "Tap to add plant photo",
                          style: const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nickname
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Plant Nickname',
                  prefixIcon: Icon(Icons.local_florist, color: Colors.yellow, size: 30),
                ),
              ),
              const SizedBox(height: 20),

              // Species Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Species',
                  prefixIcon: Icon(Icons.grass, color: Colors.green, size: 30),
                  border: OutlineInputBorder(),
                ),
                value: _selectedSpecies,
                items: <String>[
                  'Select Species',
                  'Aloe Vera',
                  'Snake Plant',
                  'Peace Lily',
                  'Spider Plant',
                  'Money Tree',
                  'Pothos',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    enabled: value != 'Select Species',
                    child: Text(
                      value,
                      style: TextStyle(
                          color: value == 'Select Species' ? Colors.grey : Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSpecies = newValue;
                    _speciesController.text = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Last Watered
              TextField(
                readOnly: true,
                controller: _lastWateredController,
                onTap: _pickLastWateredDate,
                decoration: const InputDecoration(
                  labelText: 'Last Watered',
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.blue, size: 30),
                ),
              ),
              const SizedBox(height: 20),

              // Watering Frequency
              TextField(
                readOnly: true,
                controller: _wateringFreqController..text = '$_wateringFrequency',
                decoration: const InputDecoration(
                  labelText: 'Watering Frequency (days)',
                  prefixIcon: Icon(Icons.water_drop, color: Colors.blueAccent, size: 30),
                ),
                onTap: () async {
                  final value = await showDialog<int>(
                    context: context,
                    builder: (_) => NumberPickerDialog(
                      title: 'Watering Frequency (days)',
                      initialValue: _wateringFrequency,
                    ),
                  );
                  if (value != null) {
                    setState(() => _wateringFrequency = value);
                  }
                },
              ),
              const SizedBox(height: 20),

              // Fertilizing Frequency
              TextField(
                readOnly: true,
                controller: _fertilizingFreqController..text = '$_fertilizingFrequency',
                decoration: const InputDecoration(
                  labelText: 'Fertilizing Frequency (days)',
                  prefixIcon: Icon(Icons.local_dining, color: Colors.orange, size: 30),
                ),
                onTap: () async {
                  final value = await showDialog<int>(
                    context: context,
                    builder: (_) => NumberPickerDialog(
                      title: 'Fertilizing Frequency (days)',
                      initialValue: _fertilizingFrequency,
                    ),
                  );
                  if (value != null) {
                    setState(() => _fertilizingFrequency = value);
                  }
                },
              ),
              const SizedBox(height: 20),

              // Care Notes
              TextField(
                controller: _careNotesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Care Notes',
                  prefixIcon: Icon(Icons.notes, color: Colors.brown, size: 30),
                ),
              ),
              const SizedBox(height: 10),

              // Notifications
              Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.purple, size: 30),
                  const SizedBox(width: 10),
                  const Text('Enable Notifications', style: TextStyle(fontSize: 18)),
                  const Spacer(),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) => setState(() => _notificationsEnabled = value),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.red)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _savePlant,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Save Plant', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple number picker dialog
class NumberPickerDialog extends StatefulWidget {
  final String title;
  final int initialValue;
  const NumberPickerDialog({required this.title, required this.initialValue, super.key});

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
        height: 100,
        child: Column(
          children: [
            Slider(
              value: _value.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '$_value days',
              onChanged: (v) => setState(() => _value = v.toInt()),
            ),
            Text('$_value days'),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(context, _value), child: const Text('Done')),
      ],
    );
  }
}
