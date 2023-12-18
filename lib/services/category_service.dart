import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryService {

  static Future<List<Map<String, dynamic>>> getCategories() async {
  final response = await http.get(Uri.parse('http://localhost:3000/category'));
  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((entry) => Map<String, dynamic>.from(entry)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}


  static Future<void> updateCategory(String categoryId, String title, Uint8List? imageBytes) async {
    var url = Uri.parse('http://localhost:3000/category/$categoryId');
    var request = http.MultipartRequest('PUT', url);

    request.fields['title'] = title;
    if (imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image', 
        imageBytes,
        filename: 'uploaded_image.jpg' // Nom de fichier arbitraire
      ));
    }

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  static Future<void> deleteCategory(String categoryId) async {
    final Uri uri = Uri.parse('http://localhost:3000/category/$categoryId');
    final http.Response response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

static Future<bool> addCategory(String title, String imageBase64) async {
    try {
      var response = await http.post(
        Uri.parse('http://localhost:3000/category'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'title': title,
          'imageBase64': imageBase64,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de l\'ajout de la catégorie : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la requête : $e');
      return false;
    }
  }

}
