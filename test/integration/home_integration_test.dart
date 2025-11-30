import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_trade_calc/models/player.dart';
import 'package:fantasy_trade_calc/screens/home_screen.dart';

void main() {
  // Mock players
  final mockPlayers = [
    Player(id: 1, name: 'Joe Burrow', team: 'CIN', position: 'QB', value: 95, positionRank: 1),
    Player(id: 2, name: 'Ja\'Marr Chase', team: 'CIN', position: 'WR', value: 90, positionRank: 2),
    Player(id: 3, name: 'Justin Jefferson', team: 'MIN', position: 'WR', value: 98, positionRank: 1),
  ];

  testWidgets('Add Joe Burrow to Team 1', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(initialPlayers: mockPlayers)),
    );
    await tester.pumpAndSettle();

    final searchField = find.byKey(const Key('team1_search'));
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Joe Burrow');
    await tester.pumpAndSettle();

    final playerTile = find.text('Joe Burrow');
    expect(playerTile, findsOneWidget);
    await tester.tap(playerTile);
    await tester.pumpAndSettle();

    final team1Panel = find.byKey(const Key('team1_panel'));
    expect(find.descendant(of: team1Panel, matching: find.text('Joe Burrow')), findsOneWidget);
  });

  testWidgets('Add Justin Jefferson to Team 2', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(initialPlayers: mockPlayers)),
    );
    await tester.pumpAndSettle();

    final searchField = find.byKey(const Key('team2_search'));
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Justin Jefferson');
    await tester.pumpAndSettle();

    final playerTile = find.text('Justin Jefferson');
    expect(playerTile, findsOneWidget);
    await tester.tap(playerTile);
    await tester.pumpAndSettle();

    final team2Panel = find.byKey(const Key('team2_panel'));
    expect(find.descendant(of: team2Panel, matching: find.text('Justin Jefferson')), findsOneWidget);
  });

  testWidgets('Compare trade between Team 1 and Team 2', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(initialPlayers: mockPlayers)),
    );
    await tester.pumpAndSettle();

    // Add Joe Burrow to Team 1
    await tester.enterText(find.byKey(const Key('team1_search')), 'Joe Burrow');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Joe Burrow'));
    await tester.pumpAndSettle();

    // Add Justin Jefferson to Team 2
    await tester.enterText(find.byKey(const Key('team2_search')), 'Justin Jefferson');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Justin Jefferson'));
    await tester.pumpAndSettle();

    // Tap "Compare Trade" button
    await tester.tap(find.text('Compare Trade'));
    await tester.pumpAndSettle();

    // Verify that the dialog appears
    expect(find.text('Trade Result'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
