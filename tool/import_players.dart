import 'dart:convert';
import 'package:http/http.dart' as http;

/// Replace with your own Supabase credentials
const supabaseUrl = 'https://phlzbzmgzgnkucauibhj.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBobHpiem1nemdua3VjYXVpYmhqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTg0NDY4OCwiZXhwIjoyMDc1NDIwNjg4fQ.B89Nt4U0yHUboGPCTV99gLDz3wjWHqYS5eQ3yVVzOQQ'; // only for import script

Future<void> importPlayers() async {
  print('📡 Fetching players...');
  final res = await http.get(Uri.parse('https://api.sleeper.app/v1/players/nfl'));

  if (res.statusCode != 200) {
    print('❌ Failed to fetch players: ${res.statusCode}');
    return;
  }

  final data = jsonDecode(res.body);
  final List<Map<String, dynamic>> players = [];

  data.forEach((key, player) {
    if (player['full_name'] != null && player['team'] != null) {
      players.add({
        'name': player['full_name'],
        'team': player['team'],
        'position': player['position'] ?? '',
        'base_value': 0,
        'my_custom_value': 0,
      });
    }
  });

  print('📦 Prepared ${players.length} players for upload.');

  const batchSize = 500;
  for (var i = 0; i < players.length; i += batchSize) {
    final chunk = players.skip(i).take(batchSize).toList();
    final response = await http.post(
      Uri.parse('$supabaseUrl/rest/v1/players'),
      headers: {
        'apikey': supabaseKey,
        'Authorization': 'Bearer $supabaseKey',
        'Content-Type': 'application/json',
        'Prefer': 'resolution=merge-duplicates',
      },
      body: jsonEncode(chunk),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('✅ Uploaded ${chunk.length} players (${i + chunk.length}/${players.length})');
    } else {
      print('❌ Error: ${response.statusCode} - ${response.body}');
    }
  }

  print('🎉 Done! All players imported.');
}

void main() async {
  await importPlayers();
}
