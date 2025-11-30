import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_trade_calc/models/player.dart';

void main() {
  test('Players sort by positionRank ascending', () {
    final players = [
      Player(id: 1, name: 'A', team: 'X', position: 'QB', value: 10, positionRank: 3),
      Player(id: 2, name: 'B', team: 'Y', position: 'QB', value: 10, positionRank: 1),
      Player(id: 3, name: 'C', team: 'Z', position: 'QB', value: 10, positionRank: 2),
    ];

    players.sort((a, b) => a.positionRank.compareTo(b.positionRank));

    expect(players[0].positionRank, 1);
    expect(players[1].positionRank, 2);
    expect(players[2].positionRank, 3);
  });
}
