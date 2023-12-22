class ScoreData {
  final String username;
  final double score;
  final DateTime date;

  ScoreData({required this.username, required this.score, required this.date});

  factory ScoreData.fromJson(Map<String, dynamic> json) {
    return ScoreData(
      username: json['username'],
      score: json['score'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
