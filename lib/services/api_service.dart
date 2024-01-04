import 'dart:typed_data';
import 'package:flutter_dashboard/model/score_tic_tac.dart';
import 'package:flutter_dashboard/model/text.dart';
import 'package:flutter_dashboard/model/text_consultation.dart';
import 'package:flutter_dashboard/model/score_data.dart';
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

  Future<void> createText(Texte texte) async {
  final url = Uri.parse('$baseUrl/text');

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': texte.title,
        'contenu': texte.content, // Utilisez ici 'contenu' au lieu de 'content'
      }),
    );

    if (response.statusCode == 201) {
      print('Réponse du serveur: ${response.body}');
    } else {
      print('Échec de la création du texte: ${response.statusCode}');
      print('Détails de l\'échec: ${response.body}');
    }
  } catch (e) {
    print('Erreur lors de la création du texte: $e');
  }
}

Future<void> addScore(String username, double score, [DateTime? date]) async {
  final uri = Uri.parse('$baseUrl/score'); // Remplacez par l'URL de votre serveur
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': username,
      'score': score,
      'date': date?.toIso8601String() ?? DateTime.now().toIso8601String(),
    }),
  );

  if (response.statusCode == 201) {
    // Gérer la réponse du serveur
    print('Score ajouté avec succès');
  } else {
    throw Exception('Erreur lors de l’ajout du score');
  }
}

Future<List<ScoreData>> getScores() async {
  final uri = Uri.parse('$baseUrl/score'); // Remplacez par l'URL de votre serveur
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> scoresJson = json.decode(response.body)['data']['scores'];
    return scoresJson.map((json) => ScoreData.fromJson(json)).toList();
  } else {
    throw Exception('Erreur lors de la récupération des scores');
  }
}

Future<List<ScoreTicTac>> fetchScores() async {
  try {
    final uri = Uri.parse('$baseUrl/ticTac');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData['data'] != null && jsonData['data']['scores'] != null) {
        final scoresList = jsonData['data']['scores'] as List;
        return scoresList.map((json) => ScoreTicTac.fromJson(json)).toList();
      } else {
        throw Exception('Données manquantes dans la réponse');
      }
    } else {
      throw Exception('Échec de la requête : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors de la connexion au serveur : $e');
  }
}


}