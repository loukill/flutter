import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/forum_model.dart';
import 'package:image_picker/image_picker.dart';

class AddForumForm extends StatefulWidget {
  final Function(ForumModel newForum) onAdd;

  AddForumForm({required this.onAdd});

  @override
  _AddForumFormState createState() => _AddForumFormState();
}

class _AddForumFormState extends State<AddForumForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late File? imageFile = null; // Ajout de l'état initial

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Forum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Sélectionner une image'),
            ),
            if (imageFile != null) ...[
              SizedBox(height: 16),
              Image.memory(
                imageFile!.readAsBytesSync(),
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                ForumModel newForum = ForumModel(
                  title: titleController.text,
                  description: descriptionController.text,
                  imageUrl: imageFile != null ? base64Encode(imageFile!.readAsBytesSync()) : '', id: '',
                );

                widget.onAdd(newForum);

                Navigator.pop(context);
              },
              child: Text('Ajouter le Forum'),
            ),
          ],
        ),
      ),
    );
  }
}
