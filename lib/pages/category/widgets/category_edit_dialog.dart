
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dashboard/services/category_service.dart';

class CategoryEditDialog extends StatefulWidget {
  final String categoryId;
  final String initialTitle;
  final VoidCallback onCategoryUpdated;

  CategoryEditDialog({
    required this.categoryId,
    required this.initialTitle,
    required this.onCategoryUpdated,
  });

  @override
  _CategoryEditDialogState createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  late TextEditingController _titleController;
  Uint8List? _imageBytes;
  Image? _imagePreview;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
  }

  Future<Uint8List?> pickImage() async {
  // Crée un élément input de type fichier
  final html.InputElement input = html.FileUploadInputElement() as html.InputElement
  ..accept = 'image/*';

  input.click();

  await input.onChange.first;
  if (input.files!.isEmpty) return null;

  final reader = html.FileReader();
  reader.readAsDataUrl(input.files!.first);
  await reader.onLoad.first;

  // Convertit la chaîne de données en Uint8List
  final encoded = reader.result as String;
  final stripped = encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

  return base64.decode(stripped);
}

  Future<void> _selectImage() async {
    _imageBytes = await pickImage();
    if (_imageBytes != null) {
      setState(() {
        _imagePreview = Image.memory(_imageBytes!);
      });
    }
  }

  Future<void> _updateCategory() async {
    try {
      await CategoryService.updateCategory(widget.categoryId, _titleController.text, _imageBytes);
      widget.onCategoryUpdated();
      Navigator.of(context).pop();
    } catch (e) {
      // Gérer l'erreur ici
      print('Erreur lors de la mise à jour de la catégorie: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Category'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 10),
            // Afficher un aperçu de l'image si disponible
            _imagePreview ?? SizedBox(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Update'),
          onPressed: _updateCategory,
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}