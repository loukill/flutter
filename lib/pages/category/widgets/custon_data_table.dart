import 'dart:html' as html;


import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/category/widgets/category_edit_dialog.dart';
import 'package:flutter_dashboard/services/category_service.dart';
import 'dart:convert';

class CustomDataTable extends StatefulWidget {
   final List<Map<String, dynamic>> categories;
  final Function(Map<String, dynamic>) onCategoryAdded;

   const CustomDataTable({Key? key, required this.categories, required this.onCategoryAdded}) : super(key: key);

  @override
  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void addCategory(Map<String, dynamic> newCategory) {
    widget.onCategoryAdded(newCategory); // Utiliser le callback passé au widget
  }
  

  Future<void> fetchData() async {
    try {
      data = await CategoryService.getCategories();
      setState(() {});
    } catch (e) {
      // Gérer l'erreur
      print('Error fetching data: $e');
    }
  }


  void handleEdit(String categoryId, String currentTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryEditDialog(
          categoryId: categoryId,
          initialTitle: currentTitle,
          onCategoryUpdated: () {
            fetchData();
          },
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
                Navigator.pop(context); // Close the dialog
                await CategoryService.deleteCategory(categoryId);
                fetchData(); // Refresh data after deletion
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 40, // Espacement entre les colonnes
        dataRowHeight: 100,
        columns: const [
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Actions')),
        ],
        rows: data.map((category) {
          return DataRow(
            cells: [
              DataCell(
                category['image'] != null 
                ? Image.network(
                    category['image'], // Utiliser l'URL de l'image
                    width: 80, // Largeur fixe pour l'image
                    height: 80, // Hauteur fixe pour l'image
                    fit: BoxFit.cover, // Couvre l'espace de la cellule
                  )
                : Text('No Image') // Si pas d'image disponible
              ),
              DataCell(Text(category['title'] ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => handleEdit(category['id'] ?? '', category['title'] ?? ''),
                    tooltip: 'Modifier une catégorie',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => handleDelete(category['id'] ?? ''),
                    tooltip: 'Supprimer une catégorie',
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
