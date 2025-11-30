import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_trade_calc/models/player.dart';

void main() {
  test('Filters out players with positionRank = 0', () {
    final players = [
      Player(id: 1, name: 'A', team: 'X', position: 'QB', value: 10, positionRank: 0),
      Player(id: 2, name: 'B', team: 'Y', position: 'QB', value: 10, positionRank: 5),
    ];

    final filtered = players.where((p) => p.positionRank > 0).toList();

    expect(filtered.length, 1);
    expect(filtered.first.name, 'B');
  });
}
