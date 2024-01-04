import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dashboard/model/article_model.dart';

class ArticleService {
  static const String baseUrl = 'http://localhost:9090/articals';

  static Future<List<ArticleModel>> getAllArticles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        print('Failed to load articles - Status code: ${response.statusCode}');
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Error fetching articles: $e');
      throw Exception('Failed to load articles');
    }
  }

  static Future<void> addArticle(ArticleModel article) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(article.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add article');
      }
    } catch (e) {
      print('Error adding article: $e');
      throw Exception('Failed to add article');
    }
  }

  static Future<void> updateArticle(ArticleModel article) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${article.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(article.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update article');
      }
    } catch (e) {
      print('Error updating article: $e');
      throw Exception('Failed to update article');
    }
  }

  static Future<void> deleteArticle(int articleId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$articleId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete article');
      }
    } catch (e) {
      print('Error deleting article: $e');
      throw Exception('Failed to delete article');
    }
  }

  static fetchArticles() {}
}
