import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TradeCalculatorScreen extends StatefulWidget {
  const TradeCalculatorScreen({super.key});

  @override
  State<TradeCalculatorScreen> createState() => _TradeCalculatorScreenState();
}

class _TradeCalculatorScreenState extends State<TradeCalculatorScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController team1Controller = TextEditingController();
  final TextEditingController team2Controller = TextEditingController();

  List<dynamic> team1Players = [];
  List<dynamic> team2Players = [];
  List<dynamic> searchResults = [];

  bool isSearchingTeam1 = true;
  bool isLoading = false;

  Future<void> _searchPlayers(String query) async {
  if (query.isEmpty) {
    setState(() => searchResults = []);
    return;
  }

  setState(() => isLoading = true);

  try {
    final response = await supabase
        .from('players')
        .select()
        .ilike('name', '%$query%')
        .filter('position', 'in', ['QB', 'RB', 'WR', 'TE'])
        .limit(10);

    setState(() {
      searchResults = response;
    });
  } catch (e) {
    print('Error loading players: $e');
  } finally {
    setState(() => isLoading = false);
  }
}


  void _addPlayerToTeam(dynamic player) {
    setState(() {
      if (isSearchingTeam1) {
        team1Players.add(player);
        team1Controller.clear();
      } else {
        team2Players.add(player);
        team2Controller.clear();
      }
      searchResults = [];
    });
  }

  double _calculateTotalPoints(List<dynamic> players) {
    return players.fold(
        0.0, (sum, p) => sum + (p['fantasy_points'] ?? 0.0));
  }

  void _compareTeams() {
    final team1Total = _calculateTotalPoints(team1Players);
    final team2Total = _calculateTotalPoints(team2Players);

    String result;
    if (team1Total > team2Total) {
      result = "Team 1 has the advantage!";
    } else if (team2Total > team1Total) {
      result = "Team 2 has the advantage!";
    } else {
      result = "It’s an even trade!";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Trade Result'),
        content: Text(
          'Team 1 Total: ${team1Total.toStringAsFixed(1)}\n'
          'Team 2 Total: ${team2Total.toStringAsFixed(1)}\n\n$result',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String title, List<dynamic> players) {
  return Expanded(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (players.isEmpty)
              const Text('No players added',
                  style: TextStyle(color: Colors.grey))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    // Ensure the field exists
                    if (player['base_value'] == null) {
                      player['base_value'] = 0.0;
                    }

                    return Card(
                      color: Colors.grey[100],
                      child: ListTile(
                        title: Text(player['name']),
                        subtitle: Text('${player['team']} • ${player['position']}'),
                        trailing: SizedBox(
                          width: 80,
                          child: Row(
                            children: [
                              // Editable value
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText:
                                        player['base_value'].toString(),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      player['base_value'] =
                                          double.tryParse(val) ?? 0.0;
                                    });
                                  },
                                ),
                              ),
                              // Remove button
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.redAccent),
                                onPressed: () => setState(() => players.removeAt(index)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Fantasy Trade Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Bars
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: team1Controller,
                    decoration: InputDecoration(
                      labelText: 'Search Team 1 Player',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onTap: () => setState(() => isSearchingTeam1 = true),
                    onChanged: _searchPlayers,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: team2Controller,
                    decoration: InputDecoration(
                      labelText: 'Search Team 2 Player',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onTap: () => setState(() => isSearchingTeam1 = false),
                    onChanged: _searchPlayers,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 📜 Search Results
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final player = searchResults[index];
                    return Card(
                      child: ListTile(
                        title: Text(player['name']),
                        subtitle:
                            Text('${player['team']} • ${player['position']}'),
                        trailing: TextButton(
                          child: const Text('Add'),
                          onPressed: () => _addPlayerToTeam(player),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              // 🏈 Team Comparison Display
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTeamCard('Team 1', team1Players),
                    const SizedBox(width: 12),
                    _buildTeamCard('Team 2', team2Players),
                  ],
                ),
              ),

            // 📈 Compare Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart),
                label: const Text('Compare Trade'),
                onPressed: _compareTeams,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

