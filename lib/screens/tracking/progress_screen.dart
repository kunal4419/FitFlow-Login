import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/workout_session.dart';
import '../../auth/auth_controller.dart';
import '../auth/login_screen.dart';
import '../../repositories/workout_repository.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late WorkoutRepository _workoutRepository;
  
  // Data
  List<WorkoutSession> _sessions = [];
  
  // Filters
  int _selectedDays = 90; // 7, 30, 90
  
  // Loading state
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _workoutRepository = WorkoutRepository(Supabase.instance.client);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: _selectedDays));
      
      // Load sessions and logs in date range
      final sessions = await _workoutRepository.getWorkoutSessionsInRange(
        startDate: startDate,
        endDate: endDate,
      );

      if (mounted) {
        setState(() {
          _sessions = sessions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        if (!authController.isAuthenticated) {
          return Scaffold(
            backgroundColor: const Color(0xFF0a0a0a),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0a0a0a),
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.show_chart,
                      size: 80,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Login to see your progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track your workout statistics and improvements',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFa1a1aa),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        return Scaffold(
          backgroundColor: const Color(0xFF0a0a0a),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0a0a0a),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $_error',
                          style: const TextStyle(color: Color(0xFFa1a1aa)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: const Color(0xFF6366F1),
                    onRefresh: _loadData,
                    child: _sessions.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  size: 80,
                                  color: const Color(0xFF6366F1).withOpacity(0.3),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'No workout data yet!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Start tracking to see your progress.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFFa1a1aa)),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              _buildTimeRangeFilter(),
                              const SizedBox(height: 24),
                              _buildStatsCard(),
                              const SizedBox(height: 24),
                              _buildWorkoutFrequencyChart(),
                            ],
                          ),
                  ),
      );
      },
    );
  }

  Widget _buildTimeRangeFilter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [7, 30, 90].map((days) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDays = days;
                });
                _loadData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedDays == days
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF18181b),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedDays == days
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  '${days}d',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedDays == days ? Colors.white : const Color(0xFFa1a1aa),
                    fontWeight: _selectedDays == days ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildStatsCard() {
    if (_sessions.isEmpty) return const SizedBox.shrink();

    // Calculate stats
    final pushWorkouts = _sessions.where((s) => s.workoutType.toLowerCase() == 'push').length;
    final pullWorkouts = _sessions.where((s) => s.workoutType.toLowerCase() == 'pull').length;
    final legWorkouts = _sessions.where((s) => s.workoutType.toLowerCase() == 'legs').length;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workout Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', '${_sessions.length}', Icons.fitness_center, const Color(0xFF6366F1)),
              _buildStatItem('Push', '$pushWorkouts', Icons.arrow_upward, const Color(0xFFf97316)),
              _buildStatItem('Pull', '$pullWorkouts', Icons.arrow_downward, const Color(0xFF3b82f6)),
              _buildStatItem('Legs', '$legWorkouts', Icons.directions_run, const Color(0xFF10b981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 12),
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
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFa1a1aa),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutFrequencyChart() {
    if (_sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: const Text(
          'No workout data available',
          style: TextStyle(color: Color(0xFFa1a1aa)),
        ),
      );
    }

    // Group sessions by date
    final Map<DateTime, int> workoutsByDate = {};
    for (final session in _sessions) {
      final date = DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      );
      workoutsByDate[date] = (workoutsByDate[date] ?? 0) + 1;
    }

    // Create spots for the chart
    final spots = workoutsByDate.entries.map((entry) {
      final daysSinceEpoch = entry.key.difference(DateTime(1970)).inDays.toDouble();
      return FlSpot(daysSinceEpoch, entry.value.toDouble());
    }).toList();

    spots.sort((a, b) => a.x.compareTo(b.x));

    final maxY = workoutsByDate.values.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workout Frequency',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFa1a1aa),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime(1970).add(Duration(days: value.toInt()));
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFa1a1aa),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                    left: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
                minY: 0,
                maxY: maxY + 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF6366F1),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.3),
                          const Color(0xFF6366F1).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final date = DateTime(1970).add(Duration(days: spot.x.toInt()));
                        return LineTooltipItem(
                          '${DateFormat('MMM dd').format(date)}\n${spot.y.toInt()} workout${spot.y.toInt() > 1 ? 's' : ''}',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
