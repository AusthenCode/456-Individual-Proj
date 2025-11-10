import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TradeCalculatorScreen extends StatefulWidget {
  const TradeCalculatorScreen({super.key});

  @override
  State<TradeCalculatorScreen> createState() => _TradeCalculatorScreenState();
}

class _TradeCalculatorScreenState extends State<TradeCalculatorScreen> {
  final supabase = Supabase.instance.client;

  List<dynamic> team1SearchResults = [];
  List<dynamic> team2SearchResults = [];

  List<dynamic> team1Players = [];
  List<dynamic> team2Players = [];

  TextEditingController team1SearchController = TextEditingController();
  TextEditingController team2SearchController = TextEditingController();

  bool isLoadingTeam1 = false;
  bool isLoadingTeam2 = false;

  @override
  void dispose() {
    team1SearchController.dispose();
    team2SearchController.dispose();
    super.dispose();
  }

  Future<void> _searchPlayers(String query, int teamNumber) async {
    if (query.isEmpty) {
      setState(() {
        if (teamNumber == 1) team1SearchResults = [];
        if (teamNumber == 2) team2SearchResults = [];
      });
      return;
    }

    if (teamNumber == 1) setState(() => isLoadingTeam1 = true);
    if (teamNumber == 2) setState(() => isLoadingTeam2 = true);

    try {
      final response = await supabase
          .from('players')
          .select()
          .ilike('name', '%$query%')
          .filter('position', 'in', ['QB', 'RB', 'WR', 'TE'])
          .limit(10);

      setState(() {
        if (teamNumber == 1) team1SearchResults = response;
        if (teamNumber == 2) team2SearchResults = response;
      });
    } catch (e) {
      print('Error loading players: $e');
    } finally {
      if (teamNumber == 1) setState(() => isLoadingTeam1 = false);
      if (teamNumber == 2) setState(() => isLoadingTeam2 = false);
    }
  }

  void _addPlayerToTeam(dynamic player, int teamNumber) {
    setState(() {
      final playerCopy = Map<String, dynamic>.from(player);
      if (teamNumber == 1) team1Players.add(playerCopy);
      if (teamNumber == 2) team2Players.add(playerCopy);

      if (teamNumber == 1) team1SearchResults = [];
      if (teamNumber == 2) team2SearchResults = [];

      if (teamNumber == 1) team1SearchController.clear();
      if (teamNumber == 2) team2SearchController.clear();
    });
  }

  double _calculateTotalPoints(List<dynamic> players) {
    return players.fold(
        0.0, (sum, p) => sum + (p['fantasy_points']?.toDouble() ?? 0.0));
  }

  Widget _buildPlayerCard(dynamic player) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            player['position'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(player['name'], style: const TextStyle(color: Colors.white)),
        subtitle: Text(player['team'], style: const TextStyle(color: Colors.white70)),
        trailing: Text(player['fantasy_points']?.toStringAsFixed(1) ?? '0',
            style: const TextStyle(color: Colors.greenAccent)),
      ),
    );
  }

  Widget _buildTeamPanel(
      String teamName,
      List<dynamic> teamPlayers,
      List<dynamic> searchResults,
      TextEditingController searchController,
      bool isLoading,
      int teamNumber,
      Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.grey[900],
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Team title and total points
              Text(
                teamName,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                'Total: ${_calculateTotalPoints(teamPlayers).toStringAsFixed(1)} pts',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: color),
              ),
              const Divider(color: Colors.white24),

              // Search bar
              TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search Players',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (query) => _searchPlayers(query, teamNumber),
              ),
              const SizedBox(height: 6),

              // Search results
              if (isLoading) const LinearProgressIndicator(),
              if (searchResults.isNotEmpty)
                Card(
                  color: Colors.grey[850],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final player = searchResults[index];
                      return ListTile(
                        title: Text(player['name'],
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                            '${player['team']} • ${player['position']}',
                            style: const TextStyle(color: Colors.white70)),
                        trailing: Text(player['fantasy_points']?.toStringAsFixed(1) ?? '0',
                            style: const TextStyle(color: Colors.greenAccent)),
                        onTap: () => _addPlayerToTeam(player, teamNumber),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 6),

              // Team players
              Expanded(
                child: teamPlayers.isEmpty
                    ? const Center(
                        child: Text('No players added',
                            style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        itemCount: teamPlayers.length,
                        itemBuilder: (context, index) =>
                            _buildPlayerCard(teamPlayers[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Darker background
      appBar: AppBar(
        title: const Text('Fantasy Trade Calculator'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildTeamPanel('Team 1', team1Players, team1SearchResults,
                team1SearchController, isLoadingTeam1, 1, Colors.blueAccent),
            const SizedBox(width: 8),
            _buildTeamPanel('Team 2', team2Players, team2SearchResults,
                team2SearchController, isLoadingTeam2, 2, Colors.redAccent),
          ],
        ),
      ),
    );
  }
}
