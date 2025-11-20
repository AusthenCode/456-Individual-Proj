import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://phlzbzmgzgnkucauibhj.supabase.co',      // Replace with your Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBobHpiem1nemdua3VjYXVpYmhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk4NDQ2ODgsImV4cCI6MjA3NTQyMDY4OH0.n0qn9vlEH_Q9GNL__nLJRP0OUdDvA8a9FR2En5tjDq8',            // Replace with your Supabase anon/public key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fantasy Trade Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900],
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(), // Launches HomeScreen
    );
  }
}
