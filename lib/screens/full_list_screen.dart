import 'package:flutter/material.dart';
import '../models/player.dart';

class FullPositionListScreen extends StatelessWidget {
  final String position;
  final List<Player> players;

  const FullPositionListScreen({
    super.key,
    required this.position,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = [...players]
      ..sort((a, b) => a.positionRank.compareTo(b.positionRank));

    return Scaffold(
      appBar: AppBar(
        title: Text("$position – Full Rankings"),
      ),
      body: ListView.builder(
        itemCount: sortedPlayers.length,
        itemBuilder: (context, index) {
          final p = sortedPlayers[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[800],
              child: Text(
                p.positionRank.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text("${p.name} – ${p.team}"),
            subtitle: Text("Value: ${p.value}"),
            trailing: Text(
              p.position,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
