import '../models/plant_model.dart';

class PlantData {
  static final List<Plant> _plants = [];

  static List<Plant> get allPlants => _plants;

  static void addPlant({
    required String nickname,
    required String species,
    String? imagePath,
    required int wateringFrequency,
    required int fertilizingFrequency,
    DateTime? lastWatered,
    String? careNotes,
    bool notificationsEnabled = false,
    String? userId,
  }) {
    final newPlant = Plant(
      nickname: nickname,
      species: species,
      imagePath: imagePath,
      wateringFrequency: wateringFrequency,
      fertilizingFrequency: fertilizingFrequency,
      lastWatered: lastWatered,
      careNotes: careNotes,
      userId: userId,
      notificationsEnabled: notificationsEnabled,
    );

    _plants.add(newPlant);
  }
}
