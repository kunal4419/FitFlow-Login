import 'package:flutter/material.dart';
import 'home_page.dart';
import 'extras_page.dart';
import 'tracking/history_screen.dart';
import 'tracking/bodyweight_screen.dart';
import '../widgets/live_session_banner.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const ExtrasPage();
      case 2:
        return const HistoryScreen();
      case 3:
        return const BodyweightScreen();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const LiveSessionBanner(),
          Expanded(
            child: _getScreen(_currentIndex),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Material(
          color: const Color(0xFF111111),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'Home'),
              _buildNavItem(context, 1, Icons.star, 'Extras'),
              _buildNavItem(context, 2, Icons.history, 'History'),
              _buildNavItem(context, 3, Icons.monitor_weight, 'Weight'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF6366F1) : Colors.grey;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.08),
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
