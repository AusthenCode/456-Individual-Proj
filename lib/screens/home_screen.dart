import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/player.dart';
import '../utils/trade_calc.dart';
import 'player_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;

  List<Player> allPlayers = [];
  List<Player> team1 = [];
  List<Player> team2 = [];

  List<Player> team1SearchResults = [];
  List<Player> team2SearchResults = [];

  TextEditingController team1SearchController = TextEditingController();
  TextEditingController team2SearchController = TextEditingController();

  bool isLoadingTeam1 = false;
  bool isLoadingTeam2 = false;

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  /// Load all players from Supabase
  Future<void> loadPlayers() async {
    try {
      final data = await supabase
          .from('players')
          .select()
          .order('value', ascending: false) as List<dynamic>;
      allPlayers = data.map((p) => Player.fromJson(p as Map<String, dynamic>)).toList();
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching players: $e');
    }
  }

  void _searchPlayers(String query, int teamNumber) {
    final results = allPlayers
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      if (teamNumber == 1) {
        team1SearchResults = results;
      } else {
        team2SearchResults = results;
      }
    });
  }

  void _addPlayerToTeam(Player player, int teamNumber) {
    setState(() {
      if (teamNumber == 1) {
        team1.add(player);
        team1SearchController.clear();
        team1SearchResults = [];
      } else {
        team2.add(player);
        team2SearchController.clear();
        team2SearchResults = [];
      }
    });
  }

  double _teamTotal(List<Player> team) {
    return team.fold(0.0, (sum, p) => sum + p.value);
  }

  Widget _teamPanel({
    required String title,
    required List<Player> team,
    required List<Player> searchResults,
    required TextEditingController controller,
    required bool isLoading,
    required Color color,
    required int teamNumber,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 5),
            Text('Total Value: ${_teamTotal(team).toStringAsFixed(1)}',
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Search bar
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search players',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) => _searchPlayers(query, teamNumber),
            ),

            const SizedBox(height: 5),

            // Search results
            if (isLoading) const LinearProgressIndicator(),
            if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final p = searchResults[index];
                    return ListTile(
                      title: Text(p.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${p.position} • ${p.team}',
                          style: const TextStyle(color: Colors.white70)),
                      trailing: Text(p.value.toString(),
                          style: const TextStyle(color: Colors.greenAccent)),
                      onTap: () => _addPlayerToTeam(p, teamNumber),
                    );
                  },
                ),
              ),

            const SizedBox(height: 5),

            // Team players
            Expanded(
              child: team.isEmpty
                  ? Center(
                      child: Text("No players", style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      itemCount: team.length,
                      itemBuilder: (context, index) {
                        final p = team[index];
                        return Card(
                          color: Colors.grey[850],
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(p.name, style: const TextStyle(color: Colors.white)),
                            subtitle: Text('${p.position} • ${p.team}',
                                style: const TextStyle(color: Colors.white70)),
                            trailing: Text(p.value.toString(),
                                style: const TextStyle(color: Colors.greenAccent)),
                            onTap: () {
                              setState(() {
                                team.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void compareTrade() {
    final result = TradeCalculator.compareTrades(team1, team2);
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
      appBar: AppBar(
        title: const Text('Fantasy Trade Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'View All Players',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlayerListScreen()),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          _teamPanel(
            title: 'Team 1',
            team: team1,
            searchResults: team1SearchResults,
            controller: team1SearchController,
            isLoading: isLoadingTeam1,
            color: Colors.blueAccent,
            teamNumber: 1,
          ),
          const VerticalDivider(color: Colors.white24, width: 1),
          _teamPanel(
            title: 'Team 2',
            team: team2,
            searchResults: team2SearchResults,
            controller: team2SearchController,
            isLoading: isLoadingTeam2,
            color: Colors.redAccent,
            teamNumber: 2,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: compareTrade,
          child: const Text('Compare Trade'),
        ),
      ),
    );
  }
}
