import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_trade_calc/screens/full_list_screen.dart';
import 'package:fantasy_trade_calc/models/player.dart';

void main() {
  testWidgets('Players with positionRank = 0 are excluded when passed filtered list', (WidgetTester tester) async {
    final players = [
      Player(id: 1, name: 'Unranked', team: 'X', position: 'QB', value: 10, positionRank: 0),
      Player(id: 2, name: 'Ranked', team: 'Y', position: 'QB', value: 10, positionRank: 4),
    ];

    // We emulate how your code should filter rank 0 before passing to the screen
    final filtered = players.where((p) => p.positionRank > 0).toList();

    await tester.pumpWidget(
      MaterialApp(
        home: FullPositionListScreen(position: 'QB', players: filtered),
      ),
    );

    expect(find.text('Unranked'), findsNothing);
    expect(find.text('Ranked – Y'), findsOneWidget);
  });
}
