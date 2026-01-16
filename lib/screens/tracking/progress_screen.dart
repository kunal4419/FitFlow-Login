import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/workout_session.dart';
import '../../repositories/workout_repository.dart';
import '../../widgets/auth_required.dart';

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
    return AuthRequired(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Progress'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: $_error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: _sessions.isEmpty
                        ? const Center(
                            child: Text(
                              'No workout data yet!\nStart tracking to see your progress.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              _buildTimeRangeFilter(),
                              const SizedBox(height: 24),
                              _buildStatsCard(),
                              const SizedBox(height: 24),
                              _buildWorkoutFrequencyChart(),
                            ],
                          ),
                  ),
      ),
    );
  }

  Widget _buildTimeRangeFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [7, 30, 90].map((days) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${days}d',
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: _selectedDays == days,
                selectedColor: const Color(0xFF6366F1),
                onSelected: (_) {
                  setState(() {
                    _selectedDays = days;
                  });
                  _loadData();
                },
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    if (_sessions.isEmpty) return const SizedBox.shrink();

    // Calculate stats
    final pushWorkouts = _sessions.where((s) => s.workoutType.toLowerCase() == 'push').length;
    final pullWorkouts = _sessions.where((s) => s.workoutType.toLowerCase() == 'pull').length;
    final legWorkouts = _sessions.where((s) => s.workoutType.toLowerCase() == 'legs').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workout Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', '${_sessions.length}', Icons.fitness_center, Colors.blue),
                _buildStatItem('Push', '$pushWorkouts', Icons.arrow_upward, Colors.orange),
                _buildStatItem('Pull', '$pullWorkouts', Icons.arrow_downward, Colors.blue),
                _buildStatItem('Legs', '$legWorkouts', Icons.directions_run, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutFrequencyChart() {
    if (_sessions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No workout data available'),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workout Frequency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
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
                            style: const TextStyle(fontSize: 10),
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
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[800]!),
                      left: BorderSide(color: Colors.grey[800]!),
                    ),
                  ),
                  minY: 0,
                  maxY: maxY + 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: const Color(0xFF6366F1),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF6366F1).withOpacity(0.1),
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
      ),
    );
  }
}
