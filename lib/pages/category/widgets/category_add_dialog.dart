import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter_dashboard/services/category_service.dart'; // Assurez-vous d'importer votre service

class CategoryAddDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onCategoryAdded;

  const CategoryAddDialog({Key? key, required this.onCategoryAdded}) : super(key: key);

  @override
  _CategoryAddDialogState createState() => _CategoryAddDialogState();
}

class _CategoryAddDialogState extends State<CategoryAddDialog> {
  final _titleController = TextEditingController();
  String? _imageBase64; // Pour stocker l'image en Base64

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  void _addCategory() async {
    if (_imageBase64 != null && _titleController.text.isNotEmpty) {
      // Supposons que addCategory retourne un booléen indiquant le succès de l'opération
      bool result = await CategoryService.addCategory(_titleController.text, _imageBase64!);
      if (result) {
        // Ici, on pourrait envoyer la nouvelle catégorie à onCategoryAdded
        // Mais cela nécessite que addCategory retourne des informations sur la nouvelle catégorie
        widget.onCategoryAdded({
          'title': _titleController.text,
          'image': _imageBase64 // Vous pourriez vouloir envoyer une URL ou autre chose ici
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter une Catégorie'),
      content: SingleChildScrollView( // Ajouté pour gérer le débordement
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Choisir une Image'),
            ),
            if (_imageBase64 != null) // Afficher un aperçu de l'image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(base64Decode(_imageBase64!)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: _addCategory,
          child: Text('Ajouter'),
        ),
      ],
    );
  }
}
