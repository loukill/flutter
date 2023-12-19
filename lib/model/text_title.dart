class TextTitle {
  final String id;
  final String title;

  TextTitle({required this.id, required this.title});

  factory TextTitle.fromJson(Map<String, dynamic> json) {
    return TextTitle(
      id: json['id'],
      title: json['title'],
    );
  }
}
