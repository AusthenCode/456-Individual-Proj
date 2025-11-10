import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    try {
      final response = await supabase
          .from('players')
          .select()
          .filter('position', 'in', ['QB', 'RB', 'WR', 'TE'])
          .limit(50);

      setState(() {
        players = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading players: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Players')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  title: Text(player['name']),
                  subtitle: Text(player['team'] ?? 'Unknown Team'),
                  trailing: Text(
                      player['fantasy_points']?.toStringAsFixed(1) ?? '0'),
                );
              },
            ),
    );
  }
}
