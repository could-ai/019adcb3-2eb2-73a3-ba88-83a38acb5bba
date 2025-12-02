import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final recentWorkouts = provider.workouts.take(3).toList();
    final recentWeights = provider.weightLogs.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Recent Weight Logs', () {
              Navigator.pushNamed(context, '/weight');
            }),
            if (recentWeights.isEmpty)
              const Card(child: Padding(padding: EdgeInsets.all(16), child: Text("No weight logs yet.")))
            else
              ...recentWeights.map((log) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.monitor_weight),
                      title: Text('${log.weightKg} kg'),
                      subtitle: Text(DateFormat.yMMMd().format(log.date)),
                    ),
                  )),
            const SizedBox(height: 20),
            _buildSectionHeader(context, 'Recent Workouts', () {
              Navigator.pushNamed(context, '/history'); // We'll reuse home or make a specific history page, for now just add workout
            }),
            if (recentWorkouts.isEmpty)
              const Card(child: Padding(padding: EdgeInsets.all(16), child: Text("No workouts logged yet.")))
            else
              ...recentWorkouts.map((workout) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: Text(DateFormat.yMMMd().format(workout.date)),
                      subtitle: Text('${workout.exercises.length} Exercises'),
                      onTap: () {
                        // Show details (could be a dialog or new screen)
                        showDialog(context: context, builder: (ctx) => AlertDialog(
                          title: Text(DateFormat.yMMMd().format(workout.date)),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: workout.exercises.map((e) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ...e.sets.map((s) => Text('  • ${s.weight}kg x ${s.reps} reps')),
                                  const SizedBox(height: 8),
                                ],
                              )).toList(),
                            ),
                          ),
                          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
                        ));
                      },
                    ),
                  )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'weight',
            onPressed: () => Navigator.pushNamed(context, '/weight'),
            label: const Text('Log Weight'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'workout',
            onPressed: () => Navigator.pushNamed(context, '/add_workout'),
            label: const Text('Log Workout'),
            icon: const Icon(Icons.fitness_center),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: onTap, child: const Text('View All')),
      ],
    );
  }
}
