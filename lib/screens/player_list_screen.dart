import 'package:flutter/material.dart';
import '../models/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  final supabase = Supabase.instance.client;
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    try {
      final data = await supabase.from('players').select() as List<dynamic>;
      setState(() {
        players = data.map((p) => Player.fromJson(p as Map<String, dynamic>)).toList();
      });
    } catch (e) {
      debugPrint('Error loading players: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Players')),
      body: players.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final p = players[index];
                return ListTile(
                  title: Text('${p.name} (${p.position})'),
                  subtitle: Text('${p.team} - Value: ${p.value}'),
                );
              },
            ),
    );
  }
}
