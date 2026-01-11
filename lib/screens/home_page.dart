import 'package:flutter/material.dart';
import '../widgets/drawer_menu_item.dart';
import '../widgets/stat_item.dart';
import '../widgets/workout_card.dart';
import 'workouts_page.dart';
import 'push_day_page.dart';
import 'pull_day_page.dart';
import 'leg_day_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      drawer: Drawer(
        backgroundColor: const Color(0xFF111111),
        child: ListView(
          padding: const EdgeInsets.only(top: 50),
          children: [
            DrawerMenuItem(
              icon: Icons.home,
              text: "Home",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            DrawerMenuItem(
              icon: Icons.fitness_center,
              text: "Workouts",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkoutsPage()),
                );
              },
            ),
            DrawerMenuItem(
              icon: Icons.arrow_upward,
              text: "Push",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PushDayPage()),
                );
              },
            ),
            DrawerMenuItem(
              icon: Icons.arrow_downward,
              text: "Pull",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PullDayPage()),
                );
              },
            ),
            DrawerMenuItem(
              icon: Icons.directions_run,
              text: "Legs",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LegDayPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Builder(
                builder: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    Text(
                      "FitFlow",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48), // Spacer to center the title
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF6366F1).withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                "The Ultimate Workout Split",
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "Build faster with\n",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: "Precision",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 101, 114, 233),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "A structured push-pull-legs system crafted\n"
              "using proven methods and optimal recovery\n"
              "principles.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFa1a1aa), height: 1.5),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkoutsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatItem(title: "Workout Days", value: "3"),
                  StatItem(title: "Exercises", value: "20+"),
                  StatItem(title: "Results", value: "100%"),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Stack your ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "workout\nroutine",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        TextSpan(
                          text: ".",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Mix and match exercises to rapidly optimize\nyour training. Everything fits together\nperfectly out of the box.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFa1a1aa), height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  WorkoutCard(
                    title: "Push Day",
                    description: "Chest, shoulders, and triceps workouts\ndesigned for maximum growth.",
                    color: Color(0xFF6366F1),
                    icon: Icons.fitness_center,
                  ),
                  const SizedBox(height: 16),
                  WorkoutCard(
                    title: "Pull Day",
                    description: "Back and biceps exercises to build a\npowerful upper body.",
                    color: Color(0xFF6366F1),
                    icon: Icons.accessibility_new,
                  ),
                  const SizedBox(height: 16),
                  WorkoutCard(
                    title: "Leg Day",
                    description: "Complete lower body routine for strength\nand muscle development.",
                    color: Color(0xFF6366F1),
                    icon: Icons.directions_run,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const SizedBox(height: 60),
            // Footer Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: Color(0xFF111111),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.fitness_center, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "FitFlow",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Scientifically designed workout routines for\noptimal muscle growth and recovery.",
                    style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  // Connect
                  const Text(
                    "Connect",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.code, color: Colors.white, size: 22),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF18181b),
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mail_outline, color: Colors.white, size: 22),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF18181b),
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Color(0xFFa1a1aa)),
                  const SizedBox(height: 20),
                  // Copyright
                  const Center(
                    child: Text(
                      "© 2025 FitFlow by Kunal. All rights reserved.",
                      style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Privacy and Terms
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 12),
                        ),
                      ),
                      const Text("•", style: TextStyle(color: Color(0xFFa1a1aa))),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Terms of Service",
                          style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
