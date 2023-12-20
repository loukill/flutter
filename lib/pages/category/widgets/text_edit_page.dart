import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/text.dart';
import 'package:flutter_dashboard/services/api_service.dart';

class TextEditPage extends StatefulWidget {
  final String texteId;
  final Texte currentTexte;
  final ApiService apiService;  // Ajout de l'instance ApiService

  TextEditPage({
    Key? key,
    required this.texteId,
    required this.currentTexte,
    required this.apiService,
  }) : super(key: key);

  @override
  _TextEditPageState createState() => _TextEditPageState();
}

class _TextEditPageState extends State<TextEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTexte.title);
    _contentController = TextEditingController(text: widget.currentTexte.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

 void _saveUpdate() async {
  Texte updatedTexte = Texte(
    id: widget.texteId,
    title: _titleController.text,
    content: _contentController.text,
  );

  try {
    // Appel à l'API pour mettre à jour le texte
    Texte response = await widget.apiService.updateTexte(widget.texteId, updatedTexte);

    // Si la mise à jour est réussie, revenez à l'écran précédent
    Navigator.of(context).pop();
  } catch (e) {
    // Gérer l'erreur
    final snackBar = SnackBar(content: Text('Erreur de mise à jour: ${e.toString()}'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Texte'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Contenu'),
            ),
            ElevatedButton(
              onPressed: _saveUpdate,
              child: Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
