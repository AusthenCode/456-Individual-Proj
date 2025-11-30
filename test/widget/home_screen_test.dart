import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_trade_calc/screens/home_screen.dart';
import '../mocks/mock_supabase_service.dart';
import 'package:fantasy_trade_calc/services/supabase_service.dart';

void main() {
  setUp(() {
    SupabaseService.fetchPlayersOverride = MockSupabaseService.getPlayers;
  });

  tearDown(() {
    SupabaseService.fetchPlayersOverride = null;
  });

  testWidgets("HomeScreen loads mock players", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    await tester.pumpAndSettle();

    expect(find.text("Fantasy Trade Calculator"), findsOneWidget);

    // Players should appear in search when typing
    await tester.enterText(find.byType(TextField).first, "Josh");
    await tester.pumpAndSettle();

    expect(find.text("Josh Allen"), findsOneWidget);
  });

  testWidgets("Tapping search result adds player to team", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    await tester.pumpAndSettle();

    // Search for Joe Burrow
    await tester.enterText(find.byType(TextField).first, "Joe");
    await tester.pumpAndSettle();

    expect(find.text("Joe Burrow"), findsOneWidget);

    // Tap player
    await tester.tap(find.text("Joe Burrow"));
    await tester.pumpAndSettle();

    // Should now appear on Team 1 side
    expect(find.textContaining("Joe Burrow"), findsWidgets);
  });
}
