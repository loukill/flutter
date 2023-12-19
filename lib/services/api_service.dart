import 'dart:typed_data';
import 'package:flutter_dashboard/model/text_content.dart';
import 'package:flutter_dashboard/model/text_statistic.dart';
import 'package:flutter_dashboard/model/text_title.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<TextTitle>> fetchTitles() async {
  final response = await http.get(Uri.parse('$baseUrl/txtCategory'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => TextTitle.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load titles');
  }
}


  Future<TextContent> fetchText(String txtCategoryId) async {
  final response = await http.get(Uri.parse('$baseUrl/text/parCategorie/$txtCategoryId'));

  if (response.statusCode == 200) {
    return TextContent.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load text for category $txtCategoryId');
  }
}

 Future<List<TextStatistics>> fetchStatistics(String texteId) async {
    final response = await http.get(Uri.parse('$baseUrl/text/$texteId/statistiques'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => TextStatistics.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load statistics');
    }
  }

}
