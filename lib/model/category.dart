import 'package:flutter/material.dart';
import 'package:flutter_dashboard/services/category_service.dart';

class Category {
  final String id;
  final String title;
  final String imageUrl;

  Category({required this.id, required this.title, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      title: json['title'],
      imageUrl: json['imageUrl'],
    );
  }

  // Méthode pour convertir une instance de Category en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image': imageUrl,
    };
  }
}

