import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/player.dart';

class SupabaseService {
  // Reuse the singleton Supabase client
  static final SupabaseClient _client = Supabase.instance.client;

  /// Get all players (ordered by position_rank then name)
  static Future<List<Player>> getPlayers() async {
    final List<dynamic> response = await _client
        .from('players')
        .select()
        .order('position_rank', ascending: true)
        .order('name', ascending: true);

    return response
        .map((json) => Player.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get players by position (ordered by position_rank)
  static Future<List<Player>> getPlayersByPosition(String position, {int? limit}) async {
    final query = _client
        .from('players')
        .select()
        .eq('position', position)
        .order('position_rank', ascending: true);

    if (limit != null) {
      final List<dynamic> response = await query.limit(limit);
      return response.map((j) => Player.fromJson(j as Map<String, dynamic>)).toList();
    } else {
      final List<dynamic> response = await query;
      return response.map((j) => Player.fromJson(j as Map<String, dynamic>)).toList();
    }
  }

  /// Search players by name (case-insensitive)
  static Future<List<Player>> searchPlayers(String q) async {
    final List<dynamic> response = await _client
        .from('players')
        .select()
        .ilike('name', '%$q%')
        .order('position_rank', ascending: true);

    return response.map((j) => Player.fromJson(j as Map<String, dynamic>)).toList();
  }
}
