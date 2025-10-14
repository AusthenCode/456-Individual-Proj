import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/player_list_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://phlzbzmgzgnkucauibhj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBobHpiem1nemdua3VjYXVpYmhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk4NDQ2ODgsImV4cCI6MjA3NTQyMDY4OH0.n0qn9vlEH_Q9GNL__nLJRP0OUdDvA8a9FR2En5tjDq8', // use anon key, not service key here
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Trade Calculator',
      home: PlayerListScreen(),
    );
  }
}
