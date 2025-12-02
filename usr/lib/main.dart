import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_workout_screen.dart';
import 'screens/weight_tracker_screen.dart';
import 'providers/app_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Workout Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/add_workout': (context) => const AddWorkoutScreen(),
          '/weight': (context) => const WeightTrackerScreen(),
          '/history': (context) => const HomeScreen(), // Placeholder for history, reusing home for now
        },
      ),
    );
  }
}
