import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/supabase_service.dart';
import 'full_list_screen.dart';


class PlayerListScreen extends StatelessWidget {
  const PlayerListScreen({super.key});

  Future<List<Player>> fetchPlayersByPosition(String position) async {
    final players = await SupabaseService.getPlayers();

    final filtered = players
        .where((p) => p.position == position && p.positionRank > 0)
        .toList();

    filtered.sort((a, b) => a.positionRank.compareTo(b.positionRank));

    return filtered;
  }


  Widget positionSection(
    BuildContext context, 
    String position, 
    Color color
  ) {
    return FutureBuilder(
      future: fetchPlayersByPosition(position),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final players = snapshot.data!;
        final top10 = players.take(10).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$position Rankings",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                TextButton(
                  child: const Text("More →"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullPositionListScreen(
                          position: position,
                          players: players,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ...top10.map(
              (p) => ListTile(
                title: Text("${p.name} – ${p.team}"),
                subtitle: Text("Rank ${p.positionRank}"),
                trailing: Text(p.value.toString()),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text("Player Rankings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            positionSection(context, "QB", Colors.blueAccent),
            positionSection(context, "RB", Colors.greenAccent),
            positionSection(context, "WR", Colors.orangeAccent),
            positionSection(context, "TE", Colors.purpleAccent),
          ],
        ),
      ),
    );
  }
}
