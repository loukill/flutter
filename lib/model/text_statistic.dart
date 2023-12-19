class TextStatistics {
  final String texteId;
  final int consultations;

  TextStatistics({required this.texteId, required this.consultations});

  factory TextStatistics.fromJson(Map<String, dynamic> json) {
    return TextStatistics(
      texteId: json['texteId'],
      consultations: json['consultations'],
    );
  }
}
