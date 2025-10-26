import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/plant_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Horizontal scroll section for "Upcoming Tasks"
class UpcomingTasksSection extends StatefulWidget {
  const UpcomingTasksSection({super.key});

  @override
  State<UpcomingTasksSection> createState() => _UpcomingTasksSectionState();
}

class _UpcomingTasksSectionState extends State<UpcomingTasksSection> {
  List<Map<String, dynamic>> upcomingTasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final plants = await PlantService.fetchUserPlants(token);
    List<Map<String, dynamic>> tasks = [];

    final today = DateTime.now();

    for (var plant in plants) {
      final lastWateredStr = plant['lastWatered'] ?? DateTime.now().toIso8601String();
      final lastWatered = DateTime.parse(lastWateredStr);

      final wateringFrequency = plant['wateringFrequency'] ?? 7;
      final fertilizingFrequency = plant['fertilizingFrequency'] ?? 30;

      final nextWatering = lastWatered.add(Duration(days: wateringFrequency));
      final nextFertilizing = lastWatered.add(Duration(days: fertilizingFrequency));

      if (nextWatering.isBefore(today.add(const Duration(days: 7)))) {
        tasks.add({
          'plant': plant['nickname'],
          'task': 'Water',
          'dueDate': nextWatering,
          'isDueToday': nextWatering.day == today.day &&
              nextWatering.month == today.month &&
              nextWatering.year == today.year,
        });
      }

      if (nextFertilizing.isBefore(today.add(const Duration(days: 30)))) {
        tasks.add({
          'plant': plant['nickname'],
          'task': 'Fertilize',
          'dueDate': nextFertilizing,
          'isDueToday': nextFertilizing.day == today.day &&
              nextFertilizing.month == today.month &&
              nextFertilizing.year == today.year,
        });
      }
    }

    setState(() {
      upcomingTasks = tasks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (upcomingTasks.isEmpty) {
      return Text(
        "No upcoming tasks!",
        style: GoogleFonts.inriaSerif(
          fontSize: 16,
          color: Colors.black54,
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: upcomingTasks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final task = upcomingTasks[index];
          return Container(
            width: 137,
            height: 136,
            decoration: BoxDecoration(
              color: task['isDueToday'] ? Colors.red.shade100 : const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  task['task'],
                  style: GoogleFonts.inriaSerif(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  task['plant'],
                  style: GoogleFonts.inriaSerif(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  task['isDueToday']
                      ? 'Due Today'
                      : DateFormat('MMM d').format(task['dueDate']),
                  style: GoogleFonts.inriaSerif(
                    fontSize: 12,
                    color: task['isDueToday'] ? Colors.red : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Vertical scroll section for "My Plants"
class MyPlantsSection extends StatefulWidget {
  const MyPlantsSection({super.key});

  @override
  State<MyPlantsSection> createState() => _MyPlantsSectionState();
}

class _MyPlantsSectionState extends State<MyPlantsSection> {
  List<dynamic> myPlants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final plants = await PlantService.fetchUserPlants(token);
    setState(() {
      myPlants = plants;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (myPlants.isEmpty) {
      return Text(
        "You have no plants yet!",
        style: GoogleFonts.inriaSerif(
          fontSize: 16,
          color: Colors.black54,
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: myPlants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final plant = myPlants[index];
        return Container(
          width: double.infinity,
          height: 95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(37),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: plant['imageUrl'] != null && plant['imageUrl'] != ''
                    ? NetworkImage(plant['imageUrl'])
                    : null,
                child: (plant['imageUrl'] == null || plant['imageUrl'] == '')
                    ? const Icon(Icons.local_florist, size: 28)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  plant['nickname'] ?? 'Unnamed Plant',
                  style: GoogleFonts.inriaSerif(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
