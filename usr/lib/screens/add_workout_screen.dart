import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_data.dart';
import '../providers/app_provider.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final List<Exercise> _exercises = [];
  final TextEditingController _exerciseNameController = TextEditingController();
  
  // Temp storage for adding sets
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  void _addExercise() {
    if (_exerciseNameController.text.isEmpty) return;
    setState(() {
      _exercises.add(Exercise(name: _exerciseNameController.text, sets: []));
      _exerciseNameController.clear();
    });
    Navigator.pop(context); // Close dialog
  }

  void _addSet(int exerciseIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Set'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _repsController,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final weight = double.tryParse(_weightController.text) ?? 0;
              final reps = int.tryParse(_repsController.text) ?? 0;
              if (reps > 0) {
                setState(() {
                  _exercises[exerciseIndex].sets.add(ExerciseSet(weight: weight, reps: reps));
                });
                _weightController.clear();
                _repsController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveWorkout() {
    if (_exercises.isEmpty) return;
    
    final workout = Workout(
      id: const Uuid().v4(),
      date: DateTime.now(),
      exercises: _exercises,
    );

    Provider.of<AppProvider>(context, listen: false).addWorkout(workout);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWorkout,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length + 1,
        itemBuilder: (context, index) {
          if (index == _exercises.length) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Add Exercise'),
                      content: TextField(
                        controller: _exerciseNameController,
                        decoration: const InputDecoration(labelText: 'Exercise Name'),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(onPressed: _addExercise, child: const Text('Add')),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Exercise'),
              ),
            );
          }

          final exercise = _exercises[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _addSet(index),
                  ),
                ),
                if (exercise.sets.isEmpty)
                  const Padding(padding: EdgeInsets.all(16), child: Text("No sets added."))
                else
                  ...exercise.sets.asMap().entries.map((entry) {
                    final setIndex = entry.key;
                    final set = entry.value;
                    return ListTile(
                      dense: true,
                      title: Text('Set ${setIndex + 1}: ${set.weight}kg x ${set.reps} reps'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () {
                          setState(() {
                            exercise.sets.removeAt(setIndex);
                          });
                        },
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
