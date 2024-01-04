import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_dashboard/model/forum_model.dart';

class ForumService {
  final String baseUrl;
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  ForumService(this.baseUrl);

  Future<List<ForumModel>> getForums() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/forums'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ForumModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load forums - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load forums - $e');
    }
  }

  Future<void> addForum(ForumModel newForum) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forums'),
        headers: jsonHeaders,
        body: jsonEncode(newForum.toJson()),
      );

      if (response.statusCode == 201) {
        print('Forum ajouté avec succès');
      } else {
        throw Exception('Failed to add forum - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add forum - $e');
    }
  }

  Future<void> editForum(String forumId) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/forums/$forumId'));
      if (response.statusCode != 200) {
        throw Exception('Failed to edit forum - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to edit forum - $e');
    }
  }

  Future<void> deleteForum(String forumId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/forums/$forumId'));

      if (response.statusCode == 200) {
        print('Forum supprimé avec succès');
      } else {
        throw Exception('Failed to delete forum - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete forum - $e');
    }
  }
}
