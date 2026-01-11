import 'package:flutter/material.dart';
import 'models/exercise.dart';
import 'data/exercise_data.dart';
import 'screens/hybrid_video_player.dart';

void main() {
  runApp(const FitFlowApp());
}

class FitFlowApp extends StatelessWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: '.SF Pro Display',
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  int? expandedIndex;

  void toggleExpansion(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a0a0a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "FitFlow",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                RichText(
                  text: const TextSpan(
                    text: "Choose your ",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: "workout\nsplit",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      TextSpan(
                        text: ".",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Select from our scientifically designed\nworkout routines. Each split is optimized for\nmaximum muscle growth and recovery.",
                  style: TextStyle(color: Color(0xFFa1a1aa), height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 40),
                WorkoutOptionCard(
                  title: "Push Day",
                  description: "Chest, Shoulders, Triceps",
                  fullDescription: "Focus on pushing movements that target chest, shoulders, and triceps. Perfect for building upper body pressing strength and muscle mass.",
                  duration: "45-60\nmin",
                  difficulty: "Intermediate",
                  exercises: "6\nexercises",
                  exerciseList: [
                    "Incline Dumbbell Press",
                    "Flat Dumbbell Press",
                    "Skullcrushers",
                    "Dumbbell Lateral Raises",
                    "Standing Cable Decline Press",
                    "Triceps Pushdown",
                  ],
                  color: Color(0xFF6366F1),
                  icon: Icons.fitness_center,
                  isExpanded: expandedIndex == 0,
                  onTap: () => toggleExpansion(0),
                ),
                const SizedBox(height: 16),
                WorkoutOptionCard(
                  title: "Pull Day",
                  description: "Back, Biceps",
                  fullDescription: "Pulling movements that develop back width and thickness while building strong, defined biceps.",
                  duration: "45-60\nmin",
                  difficulty: "Intermediate",
                  exercises: "6\nexercises",
                  exerciseList: [
                    "Lat Pulldown",
                    "Barbell Row",
                    "Barbell Biceps Curl",
                    "Straight Arm Lat Pulldown",
                    "Rope Hammer Curl",
                    "Reverse Pec Deck Fly",
                  ],
                  color: Color(0xFF6366F1),
                  icon: Icons.accessibility_new,
                  isExpanded: expandedIndex == 1,
                  onTap: () => toggleExpansion(1),
                ),
                const SizedBox(height: 16),
                WorkoutOptionCard(
                  title: "Leg Day",
                  description: "Quads, Hamstrings, Calves",
                  fullDescription: "Complete lower body training targeting all major muscle groups for strength, power, and stability.",
                  duration: "60-75\nmin",
                  difficulty: "Advanced",
                  exercises: "6\nexercises",
                  exerciseList: [
                    "Squat",
                    "Hamstring Leg Curl",
                    "Leg Press",
                    "Dumbbell Shoulder Press",
                    "Leg Extension",
                    "Calf Raises",
                  ],
                  color: Color(0xFF6366F1),
                  icon: Icons.directions_run,
                  isExpanded: expandedIndex == 2,
                  onTap: () => toggleExpansion(2),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;

  const StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Color(0xFFa1a1aa))),
      ],
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  const WorkoutCard({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
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
        ],
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;

  const FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 14),
        ),
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const DrawerMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF18181b), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6366F1), size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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

  const WorkoutOptionCard({
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
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

class PushDayPage extends StatelessWidget {
  const PushDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a0a0a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "FitFlow",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.fitness_center, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Push Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Chest, Shoulders & Triceps • 6 Exercises •\n45-60 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.access_time, "45-60 min"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.bar_chart, "Intermediate"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.fitness_center, "22 per each"),
                  ],
                ),
                const SizedBox(height: 30),
                ExerciseCard(exercise: ExerciseData.inclineDumbbellPress),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.flatDumbbellPress),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.skullcrushers),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.dumbbellLateralRaises),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.standingCableDeclinePress),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.tricepsPushdown),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF18181b),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFFa1a1aa), size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class PullDayPage extends StatelessWidget {
  const PullDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a0a0a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "FitFlow",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.accessibility_new, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Pull Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Back, Biceps • 6 Exercises •\n45-60 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.access_time, "45-60 min"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.bar_chart, "Intermediate"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.fitness_center, "6 exercises"),
                  ],
                ),
                const SizedBox(height: 30),
                ExerciseCard(exercise: ExerciseData.latPulldown),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.barbellRow),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.barbellBicepsCurl),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.straightArmLatPulldown),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.ropeHammerCurl),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.reversePecDeckFly),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF18181b),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFFa1a1aa), size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class LegDayPage extends StatelessWidget {
  const LegDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a0a0a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "FitFlow",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.directions_run, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Leg Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Quads, Hamstrings, Calves • 6 Exercises •\n60-75 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.access_time, "60-75 min"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.bar_chart, "Advanced"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.fitness_center, "6 exercises"),
                  ],
                ),
                const SizedBox(height: 30),
                ExerciseCard(exercise: ExerciseData.squat),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.hamstringLegCurl),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.legPress),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.dumbbellShoulderPress),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.legExtension),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.calfRaises),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF18181b),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFFa1a1aa), size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({
    required this.exercise,
  });

  void _openVideoPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HybridVideoPlayer(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => _openVideoPlayer(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Color(0xFF18181b),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exercise.description,
                        style: const TextStyle(
                          color: Color(0xFFa1a1aa),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF18181b),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    exercise.sets,
                    style: const TextStyle(
                      color: Color(0xFFa1a1aa),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF18181b),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    exercise.reps,
                    style: const TextStyle(
                      color: Color(0xFFa1a1aa),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
