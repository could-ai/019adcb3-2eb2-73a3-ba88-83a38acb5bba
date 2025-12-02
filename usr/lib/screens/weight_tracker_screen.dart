import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_data.dart';
import '../providers/app_provider.dart';

class WeightTrackerScreen extends StatefulWidget {
  const WeightTrackerScreen({super.key});

  @override
  State<WeightTrackerScreen> createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  final TextEditingController _weightController = TextEditingController();

  void _logWeight() {
    final weight = double.tryParse(_weightController.text);
    if (weight == null) return;

    final log = WeightLog(
      id: const Uuid().v4(),
      date: DateTime.now(),
      weightKg: weight,
    );

    Provider.of<AppProvider>(context, listen: false).addWeightLog(log);
    _weightController.clear();
    FocusScope.of(context).unfocus(); // Hide keyboard
  }

  @override
  Widget build(BuildContext context) {
    final logs = Provider.of<AppProvider>(context).weightLogs;

    return Scaffold(
      appBar: AppBar(title: const Text('Weight Tracker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Current Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _logWeight,
                  child: const Text('Log'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  leading: const Icon(Icons.monitor_weight_outlined),
                  title: Text('${log.weightKg} kg'),
                  subtitle: Text(DateFormat.yMMMMEEEEd().format(log.date)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<AppProvider>(context, listen: false).deleteWeightLog(log.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
