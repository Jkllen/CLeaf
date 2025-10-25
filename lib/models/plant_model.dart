class Plant {
  final String nickname;
  final String species;
  final String? imagePath;       // frontend only
  final int wateringFrequency;   // in days
  final int fertilizingFrequency; // in days
  final DateTime? lastWatered;
  final String? careNotes;
  final DateTime dateAdded;
  final String? userId;          // optional for frontend
  final bool notificationsEnabled;

  Plant({
    required this.nickname,
    required this.species,
    this.imagePath,
    required this.wateringFrequency,
    required this.fertilizingFrequency,
    this.lastWatered,
    this.careNotes,
    DateTime? dateAdded,
    this.userId,
    this.notificationsEnabled = false,
  }) : dateAdded = dateAdded ?? DateTime.now();
}
