
import 'dart:html' as html;
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dashboard/model/article_model.dart';

class ArticleForm extends StatefulWidget {
  final ArticleModel? article;

  const ArticleForm({Key? key, this.article}) : super(key: key);

  @override
  _ArticleFormState createState() => _ArticleFormState();
}

class _ArticleFormState extends State<ArticleForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  DateTime? selectedDate;
  dynamic? selectedImage;
  dynamic? selectedPdf;
  get articles => null;

  @override
  void initState() {
    super.initState();

    if (widget.article != null) {
      titleController.text = widget.article!.title;
      authorController.text = widget.article!.author;
      selectedDate = DateTime.parse(widget.article!.date);
    }
  }

Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      if (kIsWeb) {
        selectedImage = html.File([pickedFile], pickedFile.name);
      } else {
        selectedImage = File(pickedFile.path as List<Object>, pickedFile.name);
      }
    });
  }
}



  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          selectedPdf = File(result.files.single.path! as List<Object>, result.files.single.name!);
        } else {
          selectedPdf = (result.files.single.path! as List<Object>);
        }

        if (widget.article != null) {
          int index = articles.indexOf(widget.article!);
          articles[index] = widget.article!.copyWith(newPdf: selectedPdf);
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouvel article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Auteur'),
            ),
            Row(
              children: [
                Text(
                  'Date: ${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : "Sélectionner une date"}',
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Sélectionner une image'),
            ),
            if (selectedImage != null) Image.file(selectedImage! as dynamic, height: 100),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickPdf,
              child: const Text('Sélectionner un fichier PDF'),
            ),
            if (selectedPdf != null)
              Text('Selected PDF: ${selectedPdf!.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  ArticleModel newArticle = ArticleModel(
                    id: widget.article?.id ?? -1,
                    body: bodyController.text,
                    title: titleController.text,
                    author: authorController.text,
                    date: selectedDate != null
                        ? selectedDate!.toLocal().toString().split(' ')[0]
                        : "",
                    image: selectedImage,
                    pdf: selectedPdf,
                  );

                  Navigator.pop(context, newArticle);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    // Ajoutez vos règles de validation ici
    return true;
  }
}
