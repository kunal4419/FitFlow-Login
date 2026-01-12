import 'package:flutter/material.dart';
import '../screens/push_day_page.dart';
import '../screens/pull_day_page.dart';
import '../screens/leg_day_page.dart';

class WorkoutOptionCard extends StatelessWidget {
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

  const WorkoutOptionCard({super.key, 
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Color(0xFFa1a1aa),
                            fontSize: 13,
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
                                    Text(
                                      exercise,
                                      style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 13),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (title == "Push Day") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PushDayPage()),
                                  );
                                } else if (title == "Pull Day") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PullDayPage()),
                                  );
                                } else if (title == "Leg Day") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LegDayPage()),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Start $title",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                ],
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

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFF18181b),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFFa1a1aa), size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
