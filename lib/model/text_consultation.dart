class TextConsultation {
  final String title;
  final int consultationsCount;

  TextConsultation({required this.title, required this.consultationsCount});

  factory TextConsultation.fromJson(Map<String, dynamic> json) {
    return TextConsultation(
      title: json['title'],
      consultationsCount: json['consultationsCount'],
    );
  }
}
