import 'package:flutter/material.dart';
import '../models/workout_data.dart';

class AppProvider with ChangeNotifier {
  final List<Workout> _workouts = [];
  final List<WeightLog> _weightLogs = [];

  List<Workout> get workouts => List.unmodifiable(_workouts);
  List<WeightLog> get weightLogs => List.unmodifiable(_weightLogs);

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    // Sort by date descending
    _workouts.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void deleteWorkout(String id) {
    _workouts.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  void addWeightLog(WeightLog log) {
    _weightLogs.add(log);
    // Sort by date descending
    _weightLogs.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void deleteWeightLog(String id) {
    _weightLogs.removeWhere((l) => l.id == id);
    notifyListeners();
  }
}
