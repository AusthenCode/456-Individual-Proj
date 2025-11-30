import 'package:fantasy_trade_calc/models/player.dart';

class MockSupabaseService {
  /// Returns a fixed list of mock players for testing
  static Future<List<Player>> getPlayers() async {
    return [
      Player(id: 1, name: 'Tom Brady', team: 'TB', position: 'QB', value: 50, positionRank: 1),
      Player(id: 2, name: 'Derrick Henry', team: 'TEN', position: 'RB', value: 45, positionRank: 2),
      Player(id: 3, name: 'Davante Adams', team: 'LV', position: 'WR', value: 40, positionRank: 1),
    ];
  }
}
