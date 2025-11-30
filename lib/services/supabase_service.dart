import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/player.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Fetch all players, ordered by value descending
  static Future<List<Player>> getPlayers() async {
    final List<dynamic> response = await _client
        .from('players')
        .select()
        .order('value', ascending: false);

    return response
        .map((json) => Player.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch players by position, optionally limit the number
  static Future<List<Player>> getPlayersByPosition(String position, {int? limit}) async {
    var query = _client
        .from('players')
        .select()
        .eq('position', position)
        .order('position_rank', ascending: true);

    final List<dynamic> response = limit != null ? await query.limit(limit) : await query;

    return response
        .map((json) => Player.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Search players by name (case-insensitive)
  static Future<List<Player>> searchPlayers(String query) async {
    final List<dynamic> response = await _client
        .from('players')
        .select()
        .ilike('name', '%$query%')
        .order('position_rank', ascending: true);

    return response
        .map((json) => Player.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
