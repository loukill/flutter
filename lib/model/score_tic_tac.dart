class ScoreTicTac {
  final String username;
  final double score;

  ScoreTicTac({required this.username, required this.score});

  factory ScoreTicTac.fromJson(Map<String, dynamic> json) {
    return ScoreTicTac(
      username: json['userName'],
      score: json['score'].toDouble(),
    );
  }
}
