class Player {
  final int id;
  final String name;
  final String position;
  final String team;
  final double value;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.team,
    required this.value,
  });

  // Factory method to create a Player from JSON or DB row
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      position: json['position'] ?? '',
      team: json['team'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }

  // Convert Player object to JSON for SQLite insert or API usage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'team': team,
      'value': value,
    };
  }
}
