
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../model/category_model.dart';

class CustomDataTable extends StatefulWidget {
  @override
  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<Map<String, String>> data = [];

  final TextEditingController editingController = TextEditingController();
  late Future<Category> _futureCategory;

  Future<Category> updateCategory(String categoryId,String title) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/category/$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Category.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update cateory.');
    }
  }


  Future<void> deleteCategory(String categoryId) async {
    final Uri uri = Uri.parse('http://localhost:3000/category/$categoryId');

    try {
      final http.Response response = await http.delete(uri);
      if (response.statusCode == 200) {
        // Category deleted successfully
        print('Category deleted successfully');
      } else if (response.statusCode == 404) {
        // Category not found
        print('Category not found');
      } else {
        // Handle other errors
        print('Failed to delete category: ${response.body}');
      }
    } catch (error) {
      print('Error deleting category: $error');
    }
  }

  void handleEdit(String categoryId, String categoryTitle) {
    TextEditingController editingController = TextEditingController(text: categoryTitle);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: Column(
            children: [
              // TextField for editing the title
              TextField(
                controller: editingController,
                onChanged: (value) {
                  // Update the title as the user types
                  // No need to use setState here
                  print('Editing title: $value');
                },
                decoration: InputDecoration(labelText: 'New Title'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await updateCategory(categoryId, editingController.text);

                  fetchData(); // Refresh data after update
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleDelete(String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Call the deleteCategory function here
                await deleteCategory(categoryId);
                fetchData(); // Refresh data after deletion
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/category'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      print('Fetched data: $responseData'); // Add this line to print data
      setState(() {
        data = responseData.map((entry) => Map<String, String>.from(entry)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List<DataRow>.generate(
          data.length,
              (index) => DataRow(
            cells: [
              DataCell(Text(data[index]['id'] ?? '')),
              DataCell(Text(data[index]['title'] ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      handleEdit(data[index]['id'].toString(), data[index]['title'].toString());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      handleDelete(data[index]['id'].toString());
                    },
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
