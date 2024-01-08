import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dashboard/model/artical_model.dart';

class ArticalService {
  static const String baseUrl = 'http://localhost:9090/articals';

  static Future<List<ArticalModel>> getAllArticals() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ArticalModel.fromJson(json)).toList();
      } else {
        print('Failed to load articles - Status code: ${response.statusCode}');
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Error fetching articles: $e');
      throw Exception('Failed to load articles');
    }
  }

  static Future<void> addOneArticals(ArticalModel artical) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(artical.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add article');
      }
    } catch (e) {
      print('Error adding article: $e');
      throw Exception('Failed to add article');
    }
  }

 static Future<void> updateArtical(ArticalModel artical) async {
  try {
    print('Updating article with ID: ${artical.id}');
    final response = await http.put(
      Uri.parse('$baseUrl/${artical.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(artical.toJson()),
    );

    if (response.statusCode != 200) {
      print('Failed to update article - Status code: ${response.statusCode}');
      throw Exception('Failed to update article');
    }
  } catch (e) {
    print('Error updating article: $e');
    throw Exception('Failed to update article');
  }
}


  static Future<void> deleteArtical(int articalId) async {
  try {
    final response = await http.delete(Uri.parse('$baseUrl/$articalId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete article - Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting article: $e');
    throw Exception('Failed to delete article');
  }
}


  static fetchArticals() {}
}
