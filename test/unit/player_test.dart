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

  test('Player JSON serialization works correctly', () {
    final player = Player(
      id: 1,
      name: 'Player 1',
      team: 'Team A',
      position: 'RB',
      value: 15,
      positionRank: 3,
    );

    final json = player.toJson();
    expect(json['name'], 'Player 1');
    expect(json['position_rank'], 3);

    final newPlayer = Player.fromJson(json);
    expect(newPlayer.name, 'Player 1');
    expect(newPlayer.positionRank, 3);

  });

  test('Team total calculation works', () {
    final team = [
      Player(id: 1, name: 'A', team: 'X', position: 'QB', value: 10, positionRank: 1),
      Player(id: 2, name: 'B', team: 'Y', position: 'RB', value: 20, positionRank: 2),
    ];

    final total = team.fold(0, (sum, p) => sum + p.value);
    expect(total, 30);

  });
}
