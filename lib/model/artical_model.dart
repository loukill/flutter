// artical_model.dart

import 'dart:io';

class ArticalModel {
    late int id; // Make id non-nullable
  String body;
  String title;
  String author;
  String date;
  //File? image;
  //File? pdf;

  ArticalModel({
    required this.id,
    required this.body,
    required this.title,
    required this.author,
    required this.date,
   // this.image,
    //this.pdf,
  });

  factory ArticalModel.fromJson(Map<String, dynamic> json) {
    return ArticalModel(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.parse(json['id'].toString())) : 0,
      body: json['body'] ?? "N/A",
      title: json['title'] ?? "N/A",
      author: json['author'] ?? "N/A",
      date: json['date'] ?? "N/A",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'title': title,
      'author': author,
      'date': date,
      //'image': image?.path ?? '',
      //'pdf': pdf?.path ?? '',
    };
  }

  // Ajouter cette méthode pour permettre la modification de la propriété pdf
  ArticalModel copyWith({File? newPdf}) {
    return ArticalModel(
      id: id,
      body: body,
      title: title,
      author: author,
      date: date,
     // image: image,
     // pdf: newPdf ?? pdf,
    );
  }
}
