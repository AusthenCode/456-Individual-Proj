import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/player.dart';
import '../utils/trade_calc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Player>> futurePlayers;
  List<Player> teamA = [];
  List<Player> teamB = [];

  @override
  void initState() {
    super.initState();
    futurePlayers = loadPlayers();
  }

  Future<List<Player>> loadPlayers() async {
    final String response = await rootBundle.loadString('lib/data/players.json');
    final data = jsonDecode(response) as List;
    return data.map((p) => Player.fromJson(p)).toList();
  }

  void compareTrade() {
    final result = TradeCalculator.compareTrades(teamA, teamB);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Trade Result"),
        content: Text(result),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fantasy Trade Calculator')),
      body: FutureBuilder<List<Player>>(
        future: futurePlayers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final p = players[index];
                    return ListTile(
                      title: Text('${p.name} (${p.position}) - ${p.team}'),
                      subtitle: Text('Value: ${p.baseValue}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                            onPressed: () => setState(() => teamA.add(p)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                            onPressed: () => setState(() => teamB.add(p)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: compareTrade,
                child: const Text('Compare Trade'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Team A: ${teamA.length} players | Team B: ${teamB.length} players',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
