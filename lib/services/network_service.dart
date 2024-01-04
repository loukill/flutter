import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  static const String baseUrl =
      'http://localhost:3000/products'; // Replace with your backend URL

  static Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load products - Status code: ${response.statusCode}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to load products');
    }
  }

  static Future<void> addProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(productData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add product: ${response.body}');
    }
  }

  static Future<void> deleteProduct(String productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$productId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  static Future<void> updateProduct(
      String productId, Map<String, dynamic> productData) async {
    final Map<String, dynamic> requestData = {
      'id': productId,
      'name': productData['name'],
      'description': productData['description'],
      'prix': productData['prix']
          .toString(), // Convert price to string before sending
      'quantity': productData['quantity']
          .toString(), // Convert quantity to string before sending
      'category': productData['category'],
    };

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$productId'),
        body: requestData,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
