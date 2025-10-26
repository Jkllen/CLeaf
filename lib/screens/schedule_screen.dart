import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/plant_service.dart';
import 'package:cleaf/screens/main_screen.dart';

class PlantTask {
  final String plantName;
  final String taskType;
  final DateTime date;
  final bool isDueToday;
  final String? imageUrl;

  PlantTask({
    required this.plantName,
    required this.taskType,
    required this.date,
    required this.isDueToday,
    this.imageUrl,
  });
}

class ScheduleScreen extends StatefulWidget {
  final VoidCallback? goToCatalog;

  const ScheduleScreen({super.key, this.goToCatalog});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<PlantTask>> _tasks = {};
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
    final today = DateTime.now();

    List<PlantTask> allTasks = [];

    for (var plant in plants) {
      final lastWateredStr =
          plant['lastWatered'] ?? DateTime.now().toIso8601String();
      final lastWatered = DateTime.parse(lastWateredStr);

      final wateringFrequency = plant['wateringFrequency'] ?? 7;
      final fertilizingFrequency = plant['fertilizingFrequency'] ?? 30;

      final nextWatering = lastWatered.add(Duration(days: wateringFrequency));
      final nextFertilizing = lastWatered.add(
        Duration(days: fertilizingFrequency),
      );

      if (nextWatering.isBefore(today.add(const Duration(days: 7)))) {
        allTasks.add(
          PlantTask(
            plantName: plant['nickname'] ?? 'Unnamed',
            taskType: 'Water',
            date: nextWatering,
            isDueToday: _isSameDay(nextWatering, today),
            imageUrl: plant['imageUrl'],
          ),
        );
      }

      if (nextFertilizing.isBefore(today.add(const Duration(days: 30)))) {
        allTasks.add(
          PlantTask(
            plantName: plant['nickname'] ?? 'Unnamed',
            taskType: 'Fertilize',
            date: nextFertilizing,
            isDueToday: _isSameDay(nextFertilizing, today),
            imageUrl: plant['imageUrl'],
          ),
        );
      }
    }

    setState(() {
      _tasks = _groupTasksByDate(allTasks);
      isLoading = false;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Map<DateTime, List<PlantTask>> _groupTasksByDate(List<PlantTask> tasks) {
    Map<DateTime, List<PlantTask>> taskMap = {};
    for (var task in tasks) {
      final date = DateTime(task.date.year, task.date.month, task.date.day);
      if (taskMap.containsKey(date)) {
        taskMap[date]!.add(task);
      } else {
        taskMap[date] = [task];
      }
    }
    return taskMap;
  }

  List<PlantTask> _getTasksForDay(DateTime day) {
    return _tasks[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Widget _getMarkerForTask(String taskType) {
    Color color;
    IconData icon;

    switch (taskType.toLowerCase()) {
      case 'water':
        color = Colors.blue.shade400;
        icon = Icons.water_drop;
        break;
      case 'fertilize':
        color = Colors.orange.shade400;
        icon = Icons.local_florist;
        break;
      default:
        color = Colors.grey.shade400;
        icon = Icons.task;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  void _showTaskDetails(PlantTask task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    task.imageUrl != null && task.imageUrl!.isNotEmpty
                    ? NetworkImage(task.imageUrl!)
                    : null,
                child: (task.imageUrl == null || task.imageUrl!.isEmpty)
                    ? const Icon(Icons.local_florist, size: 36)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                task.plantName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.taskType,
                style: TextStyle(
                  fontSize: 18,
                  color: task.taskType.toLowerCase() == 'water'
                      ? Colors.blue
                      : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.isDueToday
                    ? 'Due Today'
                    : 'Due: ${DateFormat('MMM d, yyyy').format(task.date)}',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  widget.goToCatalog?.call(); // switch tab
                  Navigator.pop(context); // close bottom sheet
                },
                icon: const Icon(Icons.list),
                label: const Text('Go to Catalog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 87;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // CALENDAR
            TableCalendar<PlantTask>(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) =>
                  _isSameDay(_selectedDay ?? _focusedDay, day),
              eventLoader: _getTasksForDay,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events.take(3).map((task) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: _getMarkerForTask(task.taskType),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),

            const SizedBox(height: 8),

            // TASKS LIST FOR SELECTED DAY
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _getTasksForDay(_selectedDay ?? _focusedDay).isEmpty
                    ? const Center(child: Text('No tasks for this day'))
                    : ListView.builder(
                        itemCount: _getTasksForDay(
                          _selectedDay ?? _focusedDay,
                        ).length,
                        itemBuilder: (context, index) {
                          final task = _getTasksForDay(
                            _selectedDay ?? _focusedDay,
                          )[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: _getMarkerForTask(task.taskType),
                              title: Text(
                                '${task.plantName} - ${task.taskType}',
                              ),
                              subtitle: Text(
                                task.isDueToday
                                    ? 'Due Today'
                                    : DateFormat('MMM d').format(task.date),
                              ),
                              onTap: () => _showTaskDetails(task),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
