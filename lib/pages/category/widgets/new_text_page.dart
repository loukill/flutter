import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/text.dart';
import 'package:flutter_dashboard/services/api_service.dart';

class NewTextPage extends StatefulWidget {
  final ApiService apiService;

  NewTextPage({required this.apiService});

  @override
  _NewTextPageState createState() => _NewTextPageState();
}

class _NewTextPageState extends State<NewTextPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

void _submitText() {
  if (_formKey.currentState!.validate()) {
    widget.apiService.createText(
      Texte.newText(
        title: _titleController.text, 
        content: _contentController.text,
      ),
    ).then((_) {
      Navigator.of(context).pop();
    }).catchError((error) {
      // Gérer l'erreur ici
    });
  }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Nouveau Texte', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black87, 
    ),
    body: SingleChildScrollView( // Pour éviter les débordements sur les petits écrans
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value!.isEmpty ? 'Entrez un titre' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Contenu',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Pour aligner le label avec le texte
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 6,
                validator: (value) => value!.isEmpty ? 'Entrez du contenu' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitText,
                child: Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[800],
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
