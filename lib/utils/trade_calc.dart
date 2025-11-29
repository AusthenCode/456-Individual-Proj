import '../models/player.dart';

class TradeCalculator {
  static double calculateTotal(List<Player> players) {
    return players.fold(0, (sum, p) => sum + p.value);
  }

  static String compareTrades(List<Player> teamA, List<Player> teamB) {
    double totalA = calculateTotal(teamA);
    double totalB = calculateTotal(teamB);
    double diff = (totalA - totalB).abs();

    if (diff < 5) {
      return "Fair Trade! (A: $totalA vs B: $totalB)";
    } else if (totalA > totalB) {
      return "Team A wins by ${diff.toStringAsFixed(1)} points!";
    } else {
      return "Team B wins by ${diff.toStringAsFixed(1)} points!";
    }
  }
}
