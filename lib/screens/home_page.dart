import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/workout_card.dart';
import '../auth/auth_controller.dart';
import 'profile_page.dart';
import 'auth/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _workoutSectionKey = GlobalKey();
  int? expandedIndex;

  void toggleExpansion(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  void _scrollToWorkouts() {
    final RenderBox? renderBox =
        _workoutSectionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero).dy;
      final offset = _scrollController.offset + position - 100;

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: Stack(
                  children: [
                    Center(
                      child: const Text(
                        "FitFlow",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (authController.isAuthenticated)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfilePage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 3, top: 4),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFF6366F1).withOpacity(0.2),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF6366F1),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.15),
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
              // ...existing code...
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
                        colors: [
                          Color.fromARGB(255, 101, 103, 233),
                          Color.fromARGB(255, 97, 110, 233),
                        ],
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
                      onPressed: _scrollToWorkouts,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('3', 'Workout\nDays'),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          _buildStatColumn('20+', 'Exercises'),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          _buildStatColumn('100%', 'Results'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    key: _workoutSectionKey,
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
                          style: TextStyle(
                            color: Color(0xFFa1a1aa),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 50),
                        WorkoutCard(
                          title: "Push Day",
                          description: "Chest + Triceps.",
                          fullDescription:
                              "Focus on pushing movements that target chest, shoulders, and triceps. Perfect for building upper body pressing strength and muscle mass.",
                          duration: "45-60\nmin",
                          difficulty: "Intermediate",
                          exercises: "6\nexercises",
                          exerciseList: const [
                            "Incline Dumbbell Press",
                            "Flat Dumbbell Press",
                            "Skullcrushers",
                            "Dumbbell Lateral Raises",
                            "Standing Cable Decline Press",
                            "Triceps Pushdown",
                          ],
                          color: Color(0xFFf97316),
                          icon: FontAwesomeIcons.dumbbell,
                          isExpanded: expandedIndex == 0,
                          onTap: () => toggleExpansion(0),
                        ),
                        const SizedBox(height: 16),
                        WorkoutCard(
                          title: "Pull Day",
                          description: "Back + Biceps.",
                          fullDescription:
                              "Pulling movements that develop back width and thickness while building strong, defined biceps.",
                          duration: "45-60\nmin",
                          difficulty: "Intermediate",
                          exercises: "6\nexercises",
                          exerciseList: const [
                            "Lat Pulldown",
                            "Barbell Row",
                            "Barbell Biceps Curl",
                            "Straight Arm Lat Pulldown",
                            "Rope Hammer Curl",
                            "Reverse Pec Deck Fly",
                          ],
                          color: Color(0xFF3b82f6),
                          icon: FontAwesomeIcons.personSwimming,
                          isExpanded: expandedIndex == 1,
                          onTap: () => toggleExpansion(1),
                        ),
                        const SizedBox(height: 16),
                        WorkoutCard(
                          title: "Leg Day",
                          description: "Quads + Hamstrings.",
                          fullDescription:
                              "Complete lower body training targeting all major muscle groups for strength, power, and stability.",
                          duration: "60-75\nmin",
                          difficulty: "Advanced",
                          exercises: "6\nexercises",
                          exerciseList: const [
                            "Squat",
                            "Hamstring Leg Curl",
                            "Leg Press",
                            "Dumbbell Shoulder Press",
                            "Leg Extension",
                            "Calf Raises",
                          ],
                          color: Color(0xFF10b981),
                          icon: FontAwesomeIcons.personRunning,
                          isExpanded: expandedIndex == 2,
                          onTap: () => toggleExpansion(2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Footer Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
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
                        const Text(
                          "FitFlow",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Scientifically designed workout routines for\noptimal muscle growth and recovery.",
                          style: TextStyle(
                            color: Color(0xFFa1a1aa),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Connect
                        const Text(
                          "Connect",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final Uri url = Uri.parse(
                                  'https://github.com/kunal4419',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.github,
                                color: Colors.white,
                                size: 22,
                              ),
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
                              onPressed: () async {
                                final Uri url = Uri.parse(
                                  'mailto:patelkunal4419@gmail.com',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.envelope,
                                color: Colors.white,
                                size: 22,
                              ),
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
                            style: TextStyle(
                              color: Color(0xFFa1a1aa),
                              fontSize: 12,
                            ),
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
                                style: TextStyle(
                                  color: Color(0xFFa1a1aa),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Text(
                              "•",
                              style: TextStyle(color: Color(0xFFa1a1aa)),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Terms of Service",
                                style: TextStyle(
                                  color: Color(0xFFa1a1aa),
                                  fontSize: 12,
                                ),
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

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.grey[400], height: 1.2),
        ),
      ],
    );
  }
}
