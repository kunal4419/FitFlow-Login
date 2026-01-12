import 'package:flutter/material.dart';
import '../screens/push_day_page.dart';
import '../screens/pull_day_page.dart';
import '../screens/leg_day_page.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String description;
  final String fullDescription;
  final String duration;
  final String difficulty;
  final String exercises;
  final List<String> exerciseList;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final bool isExpanded;

  const WorkoutCard({super.key, 
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.duration,
    required this.difficulty,
    required this.exercises,
    required this.exerciseList,
    required this.color,
    required this.icon,
    required this.onTap,
    required this.isExpanded,
  });

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF18181b),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFa1a1aa), size: 16),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFa1a1aa),
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToWorkoutPage(BuildContext context) {
    Widget? page;
    if (title == "Push Day") {
      page = const PushDayPage();
    } else if (title == "Pull Day") {
      page = const PullDayPage();
    } else if (title == "Leg Day") {
      page = const LegDayPage();
    }
    
    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF111111),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            color: Color(0xFFa1a1aa),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFFa1a1aa),
                      size: 24,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            fullDescription,
                            style: const TextStyle(
                              color: Color(0xFFa1a1aa),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatChip(Icons.access_time, duration),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatChip(Icons.bar_chart, difficulty),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatChip(Icons.fitness_center, exercises),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Exercise List:",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...exerciseList.map((exercise) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: color, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        exercise,
                                        style: const TextStyle(
                                          color: Color(0xFFa1a1aa),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _navigateToWorkoutPage(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Start Workout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
