import 'dart:typed_data';
import 'package:flutter_dashboard/model/text.dart';
import 'package:flutter_dashboard/model/text_consultation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Texte>> getAllTextes() async {
  final response = await http.get(Uri.parse('$baseUrl/text'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => Texte.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load textes');
  }
}

Future<Texte> createTexte(Texte texte) async {
  final response = await http.post(
    Uri.parse('$baseUrl/text'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'title': texte.title,
      'content': texte.content,
      // Ajoutez d'autres champs si nécessaire
    }),
  );

  if (response.statusCode == 201) {
    return Texte.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create texte');
  }
}

 Future<Texte> updateTexte(String texteId, Texte texte) async {
    final response = await http.put(
      Uri.parse('$baseUrl/text/$texteId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': texte.title,
        'content': texte.content,
        // Ajoutez d'autres champs si nécessaire
      }),
    );

    if (response.statusCode == 200) {
      return Texte.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update texte');
    }
  }

Future<void> deleteTexte(String id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/text/$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete texte');
  }
}

Future<List<TextConsultation>> getTextConsultations() async {
    final response = await http.get(Uri.parse('$baseUrl/consultations'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => TextConsultation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load consultations');
    }
  }

}