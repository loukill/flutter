import 'dart:io';

class ArticleModel {
  int id;
  String body ;
  String title;
  String author;
  String date;
  File? image;
  File? pdf;

  ArticleModel({
    required this.id,
    required this.body,
    required this.title,
    required this.author,
    required this.date,
    this.image,
    this.pdf,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      body: json['body'] ?? "N/A",
      title: json['title'] ?? "N/A",
      author: json['author'] ?? "N/A",
      date: json['date'] ?? "N/A",
      image: json['image'] != null ? File(json['image']) : null,
      pdf: json['pdf'] != null ? File(json['pdf']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body' :body,
      'title': title,
      'author': author,
      'date': date,
      'image': image?.path,
      'pdf': pdf?.path,
    };
  }

  // Ajouter cette méthode pour permettre la modification de la propriété pdf
  ArticleModel copyWith({File? newPdf}) {
    return ArticleModel(
      id: id,
      body: body,
      title: title,
      author: author,
      date: date,
      image: image,
      pdf: newPdf ?? pdf,
    );
  }
}