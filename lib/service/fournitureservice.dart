import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:Dyslire/model/fourniture.dart';

class FournitureApiService {
  final String baseUrl =
      'https://127.0.0.1:9090'; // Replace with your API base URL

  Future<List<fourniture>> getAllFournitures() async {
    final response = await http.get(Uri.parse('$baseUrl/fournitures'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => fourniture.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load fournitures');
    }
  }

  Future<void> addFourniture(fourniture newFourniture) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fournitures'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newFourniture.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add fourniture');
    }
  }

  Future<void> deleteFourniture(int fournitureId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/fournitures/$fournitureId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete fourniture');
    }
  }
}
