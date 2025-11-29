class Player {
  final int id;
  final String name;
  final String team;        // You said this is correct now
  final String position;    // Corrected (no longer swapped)
  final int value;
  final int positionRank;

  Player({
    required this.id,
    required this.name,
    required this.team,
    required this.position,
    required this.value,
    required this.positionRank,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      team: json['team'],
      position: json['position'],
      value: json['value'],
      positionRank: json['position_rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'team': team,
      'position': position,
      'value': value,
      'position_rank': positionRank,
    };
  }
}
