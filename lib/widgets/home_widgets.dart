import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Horizontal scroll section for "Upcoming Tasks"
class UpcomingTasksSection extends StatelessWidget {
  const UpcomingTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder data — replace later with dynamic plant/task data
    final tasks = List.generate(3, (index) => 'Task ${index + 1}');

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 137,
            height: 136,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6), // from rectangle_7.xml
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                tasks[index],
                style: GoogleFonts.inriaSerif(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Vertical scroll section for "My Plants"
class MyPlantsSection extends StatelessWidget {
  const MyPlantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder data — replace later with actual plants
    final plants = List.generate(5, (index) => 'Plant ${index + 1}');

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), // let parent scroll
      shrinkWrap: true,
      itemCount: plants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          height: 95,
          decoration: BoxDecoration(
            color: Colors.white, // from rectangle_8.xml
            borderRadius: BorderRadius.circular(37),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              plants[index],
              style: GoogleFonts.inriaSerif(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}
