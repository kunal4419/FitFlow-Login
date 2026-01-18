import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetData {
  double? weight;
  int? reps;
  bool completed;

  SetData({
    this.weight,
    this.reps,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
    'weight': weight,
    'reps': reps,
    'completed': completed,
  };

  factory SetData.fromJson(Map<String, dynamic> json) => SetData(
    weight: json['weight']?.toDouble(),
    reps: json['reps']?.toInt(),
    completed: json['completed'] ?? false,
  );
}

class WorkoutSessionController extends ChangeNotifier {
  // Session state
  bool _isSessionActive = false;
  String? _workoutType;
  Duration _elapsedTime = Duration.zero;
  DateTime? _startTime;
  DateTime? _lastActivityTime;
  Map<String, List<SetData>> _exerciseSets = {};
  
  // Timers
  Timer? _workoutTimer;
  Timer? _inactivityCheckTimer;
  Stopwatch? _stopwatch;
  
  // Getters
  bool get isSessionActive => _isSessionActive;
  String? get workoutType => _workoutType;
  Duration get elapsedTime => _elapsedTime;
  DateTime? get startTime => _startTime;
  DateTime? get lastActivityTime => _lastActivityTime;
  Map<String, List<SetData>> get exerciseSets => Map.from(_exerciseSets);
  
  // Start a new workout session
  void startSession(String workoutType, Map<String, List<SetData>> initialSets) {
    _isSessionActive = true;
    _workoutType = workoutType;
    _startTime = DateTime.now();
    _lastActivityTime = DateTime.now();
    _exerciseSets = Map.from(initialSets);
    _elapsedTime = Duration.zero;
    
    // Start workout timer
    _stopwatch = Stopwatch()..start();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedTime = _stopwatch!.elapsed;
      notifyListeners();
    });
    
    // Start inactivity check timer (check every minute)
    _inactivityCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkInactivity();
    });
    
    // Save to storage
    saveSessionToStorage();
    
    notifyListeners();
  }
  
  // Resume existing session (when navigating back)
  void resumeSession() {
    // Session is already active, just notify listeners
    notifyListeners();
  }
  
  // Update session data (called when user modifies sets)
  void updateSessionData(Map<String, List<SetData>> updatedSets) {
    _exerciseSets = Map.from(updatedSets);
    _lastActivityTime = DateTime.now();
    // Save to storage
    saveSessionToStorage();
    notifyListeners();
  }
  
  // Update activity timestamp (called on any user interaction)
  void updateActivity() {
    _lastActivityTime = DateTime.now();
  }
  
  // Check for inactivity timeout (1 hour)
  void _checkInactivity() {
    if (_lastActivityTime != null) {
      final inactiveDuration = DateTime.now().difference(_lastActivityTime!);
      if (inactiveDuration.inHours >= 1) {
        // Auto-cancel session after 1 hour of inactivity
        cancelSession(autoTimeout: true);
      }
    }
  }
  
  // Cancel/end the session
  void cancelSession({bool autoTimeout = false}) {
    _isSessionActive = false;
    _workoutType = null;
    _startTime = null;
    _lastActivityTime = null;
    _exerciseSets.clear();
    _elapsedTime = Duration.zero;
    
    // Stop timers
    _workoutTimer?.cancel();
    _workoutTimer = null;
    _inactivityCheckTimer?.cancel();
    _inactivityCheckTimer = null;
    _stopwatch?.stop();
    _stopwatch = null;
    
    // Clear from storage
    clearSessionFromStorage();
    
    notifyListeners();
  }
  
  // Get formatted duration string
  String getFormattedDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_elapsedTime.inHours);
    final minutes = twoDigits(_elapsedTime.inMinutes.remainder(60));
    final seconds = twoDigits(_elapsedTime.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
  
  // Storage methods
  static const String _sessionKey = 'workout_session';
  
  Future<void> saveSessionToStorage() async {
    if (!_isSessionActive) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = {
        'isActive': _isSessionActive,
        'workoutType': _workoutType,
        'startTime': _startTime?.toIso8601String(),
        'lastActivityTime': _lastActivityTime?.toIso8601String(),
        'exerciseSets': _exerciseSets.map((key, value) => 
          MapEntry(key, value.map((set) => set.toJson()).toList())
        ),
      };
      await prefs.setString(_sessionKey, jsonEncode(sessionData));
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }
  
  Future<void> loadSessionFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionString = prefs.getString(_sessionKey);
      
      if (sessionString == null) return;
      
      final sessionData = jsonDecode(sessionString) as Map<String, dynamic>;
      
      // Check if session is still valid (not expired)
      final lastActivity = sessionData['lastActivityTime'] != null
        ? DateTime.parse(sessionData['lastActivityTime'])
        : null;
      
      if (lastActivity != null) {
        final inactiveDuration = DateTime.now().difference(lastActivity);
        if (inactiveDuration.inHours >= 1) {
          // Session expired, clear it
          await clearSessionFromStorage();
          return;
        }
      }
      
      // Restore session state
      _isSessionActive = sessionData['isActive'] ?? false;
      _workoutType = sessionData['workoutType'];
      _startTime = sessionData['startTime'] != null
        ? DateTime.parse(sessionData['startTime'])
        : null;
      _lastActivityTime = lastActivity;
      
      // Restore exercise sets
      final setsData = sessionData['exerciseSets'] as Map<String, dynamic>?;
      if (setsData != null) {
        _exerciseSets = setsData.map((key, value) {
          final setsList = (value as List)
            .map((setJson) => SetData.fromJson(setJson as Map<String, dynamic>))
            .toList();
          return MapEntry(key, setsList);
        });
      }
      
      // Calculate elapsed time from start time
      if (_startTime != null) {
        _elapsedTime = DateTime.now().difference(_startTime!);
        
        // Start timers
        _stopwatch = Stopwatch()..start();
        _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          _elapsedTime = _stopwatch!.elapsed + DateTime.now().difference(_startTime!);
          notifyListeners();
        });
        
        _inactivityCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
          _checkInactivity();
        });
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading session: $e');
      await clearSessionFromStorage();
    }
  }
  
  Future<void> clearSessionFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);
    } catch (e) {
      debugPrint('Error clearing session: $e');
    }
  }
  
  @override
  void dispose() {
    _workoutTimer?.cancel();
    _inactivityCheckTimer?.cancel();
    _stopwatch?.stop();
    super.dispose();
  }
}
