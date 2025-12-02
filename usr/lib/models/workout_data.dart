import 'package:flutter/foundation.dart';

class ExerciseSet {
  double weight;
  int reps;

  ExerciseSet({required this.weight, required this.reps});
}

class Exercise {
  String name;
  List<ExerciseSet> sets;

  Exercise({required this.name, required this.sets});
}

class Workout {
  String id;
  DateTime date;
  List<Exercise> exercises;

  Workout({required this.id, required this.date, required this.exercises});
}

class WeightLog {
  String id;
  DateTime date;
  double weightKg;

  WeightLog({required this.id, required this.date, required this.weightKg});
}
