class Player {
  final String name;
  final String team;
  final String position;
  final double baseValue;      // The value from Supabase
  final int rank;              // Overall rank
  final int positionRank;      // Rank within their position (e.g., RB11)

  Player({
    required this.name,
    required this.team,
    required this.position,
    required this.baseValue,
    required this.rank,
    required this.positionRank,
  });

  // Factory to create a Player from Supabase JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] ?? 'Unknown',
      team: json['team'] ?? 'Unknown',
      position: json['position'] ?? '',
      baseValue: (json['base_value'] ?? 0).toDouble(),
      rank: json['rank'] ?? 0,
      positionRank: json['position_rank'] ?? 0,
    );
  }

  // Convert Player object to JSON for Supabase inserts/updates
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'team': team,
      'position': position,
      'base_value': baseValue,
      'rank': rank,
      'position_rank': positionRank,
    };
  }

  double calculateFantasyPoints(Map<String, dynamic> player) {
  final position = player['position'];
  double points = 0.0;

  if (position == 'QB') {
    points += (player['passing_yards'] ?? 0) / 25;
    points += (player['passing_tds'] ?? 0) * 4;
    points -= (player['interceptions'] ?? 0) * 2;
  } else if (['RB', 'WR', 'TE'].contains(position)) {
    points += (player['rushing_yards'] ?? 0) / 10;
    points += (player['receiving_yards'] ?? 0) / 10;
    points += (player['rushing_tds'] ?? 0) * 6;
    points += (player['receiving_tds'] ?? 0) * 6;
    points += (player['receptions'] ?? 0) * 1; // PPR
  }

    return points;
  }

}
