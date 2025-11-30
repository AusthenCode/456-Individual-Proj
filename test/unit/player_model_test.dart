import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_trade_calc/models/player.dart';

void main() {
  group('Player Model', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 10,
        'name': 'Josh Allen',
        'team': 'BUF',
        'position': 'QB',
        'value': 95,
        'position_rank': 1,
      };

      final player = Player.fromJson(json);

      expect(player.id, 10);
      expect(player.name, 'Josh Allen');
      expect(player.team, 'BUF');
      expect(player.position, 'QB');
      expect(player.value, 95);
      expect(player.positionRank, 1);
    });

    test('toJson outputs correctly', () {
      final player = Player(
        id: 1,
        name: 'Patrick Mahomes',
        team: 'KC',
        position: 'QB',
        value: 99,
        positionRank: 1,
      );

      final json = player.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Patrick Mahomes');
      expect(json['team'], 'KC');
      expect(json['position'], 'QB');
      expect(json['value'], 99);
      expect(json['position_rank'], 1);
    });
  });
}
