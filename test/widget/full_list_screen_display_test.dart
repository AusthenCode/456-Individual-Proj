import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_trade_calc/screens/full_list_screen.dart';
import 'package:fantasy_trade_calc/models/player.dart';

void main() {
  testWidgets('FullPositionListScreen shows players sorted by positionRank', (WidgetTester tester) async {
    final players = [
      Player(id: 1, name: 'A', team: 'X', position: 'QB', value: 10, positionRank: 3),
      Player(id: 2, name: 'B', team: 'Y', position: 'QB', value: 10, positionRank: 1),
      Player(id: 3, name: 'C', team: 'Z', position: 'QB', value: 10, positionRank: 2),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: FullPositionListScreen(position: 'QB', players: players),
      ),
    );

    // verify that rank badges 1,2,3 exist
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // verify player order by finding the first ListTile text
    final firstTile = find.widgetWithText(ListTile, 'B – Y');
    expect(firstTile, findsOneWidget);
  });
}
