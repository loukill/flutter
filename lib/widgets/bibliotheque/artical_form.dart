// artical_form.dart

import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/services/ArticalService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dashboard/model/artical_model.dart';

class ArticalForm extends StatefulWidget {
  final ArticalModel? artical;

  static var length;

  const ArticalForm({Key? key, this.artical}) : super(key: key);

  @override
  _ArticalFormState createState() => _ArticalFormState();
}

class _ArticalFormState extends State<ArticalForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  DateTime? selectedDate;
  //dynamic? selectedImage;
  List<ArticalModel> articals = [];

  @override
  void initState() {
    super.initState();

    if (widget.artical != null) {
      titleController.text = widget.artical!.title;
      authorController.text = widget.artical!.author;
      bodyController.text = widget.artical!.body;
      selectedDate = DateTime.parse(widget.artical!.date);
    }
  }

 Future<void> fetchArticals() async {
  try {
    List<ArticalModel> fetchedArticals = await ArticalService.getAllArticals();
    setState(() {
      articals = fetchedArticals;
    });
    print('Fetched ${articals.length} articals: $articals');
  } catch (error) {
    print('Error fetching articals: $error');
  }
}

 /* Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          selectedImage = html.File([pickedFile], pickedFile.name);
        } else {
          selectedImage = File(pickedFile.path);
        }
      });
    }
  }*/

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
            TextField(
              controller: bodyController,
              maxLines: null,  // Allow multiple lines for the body
              decoration: const InputDecoration(labelText: 'Body'),
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
            /*const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Sélectionner une image'),
            ),
            if (selectedImage != null) Image.file(selectedImage! as dynamic, height: 100),
            const SizedBox(height: 16),*/
            ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  ArticalModel newArtical = ArticalModel(
                    id: widget.artical?.id ?? 1,
                    body: bodyController.text,
                    title: titleController.text,
                    author: authorController.text,
                    date: selectedDate != null
                        ? selectedDate!.toLocal().toString().split(' ')[0]
                        : "",
                    //image: selectedImage,
                  );
                  Navigator.pop(context, newArtical);
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
