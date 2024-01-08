import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/artical_model.dart';
import 'package:flutter_dashboard/services/ArticalService.dart';

import 'package:flutter_dashboard/widgets/bibliotheque/artical_form.dart';

class ArticalManagementScreen extends StatefulWidget {
  const ArticalManagementScreen({Key? key, required List articals}) : super(key: key);

  @override
  _ArticalManagementScreenState createState() => _ArticalManagementScreenState();
}

class _ArticalManagementScreenState extends State<ArticalManagementScreen> {
  List<ArticalModel> articals = [];
  List<ArticalModel> filteredArticals = [];
  TextEditingController searchController = TextEditingController();
  
  get id => null;
  
  get body => null;
  
  get title => null;
  
  get author => null;
  
  get date => null;

  @override
  void initState() {
    super.initState();
    _loadArticals();
  }

void printArticals() {
  filteredArticals.forEach((artical) {
    print('Artical ID: ${artical.id}, Title: ${artical.title}, Author: ${artical.author}, Body: ${artical.body}, Date: ${artical.date}');
  });
}

Future<void> _loadArticals() async {
    try {
      // Assurez-vous que votre service renvoie une liste valide
      List<ArticalModel> fetchedArticals = await ArticalService.getAllArticals();
      setState(() {
        articals = fetchedArticals;
        filteredArticals = articals; // Initialisez également filteredArticals ici
      });
      print('Filtered Articals: $filteredArticals');
    } catch (e) {
      print('Error loading articles: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    int totalPublishedArticals = articals.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des articles'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
  setState(() {
    filteredArticals = articals
        .where((artical) =>
            artical.title.toLowerCase().contains(value.toLowerCase()))
        .toList();
  });
},

              decoration: InputDecoration(
                labelText: 'Rechercher par titre',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Titre')),
              DataColumn(label: Text('Auteur')),
              DataColumn(label: Text('Body')),
              DataColumn(label: Text('Date')),
              
              //DataColumn(label: Text('Image')),
              //DataColumn(label: Text('PDF')),
              DataColumn(label: Text('Actions')),
            ],
            rows: filteredArticals.map(
              (artical) => DataRow(cells: [
                DataCell(Text(artical.id.toString())),
                DataCell(Text(artical.title)),
                DataCell(Text(artical.author)),
                DataCell(Text(artical.body)),
                DataCell(Text(artical.date)),
                

                /*DataCell(
                  artical.image != null
                      ? Image.file(artical.image!, height: 50)
                      : const Text('No Image'),
                ),*/
               /* DataCell(
                  Text(article.pdf != null ? 'PDF disponible' : 'Aucun PDF'),
                ),*/
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticalForm(artical: artical),
                          ),
                        );

                        if (result != null && result is ArticalModel) {
                          print(ArticalModel(id: id, body: body, title: title, author: author, date: date ));
                          await _updateArtical(result);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _deleteArtical(artical.id);
                      },
                    ),
                  ],
                )),
              ]), 
            ).toList(),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total d\'articles publiés: $totalPublishedArticals'),
              FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArticalForm(),
                    ),
                  );

                  if (result != null && result is ArticalModel) {
                    await addOneArticals(result);
                  }
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addOneArticals(ArticalModel artical) async {
    try {
      await ArticalService.addOneArticals(artical);
      await _loadArticals();
    } catch (e) {
      print('Error adding article: $e');
    }
  }

 Future<void> _updateArtical(ArticalModel artical) async {
  try {
    // Assurez-vous que l'ID de l'article est correct
    if (artical.id != 0) {
      await ArticalService.updateArtical(artical);
      await _loadArticals();
    } else {
      print('Error updating article: Article ID is null');
    }
  } catch (e) {
    print('Error updating article: $e');
  }
}


 Future<void> _deleteArtical(int? articalId) async {
  try {
    if (articalId != null) {
      await ArticalService.deleteArtical(articalId);
      await _loadArticals();
    } else {
      print('Error deleting article: Article ID is null');
    }
  } catch (e) {
    print('Error deleting article: $e');
    // Gérer l'erreur de suppression d'article ici
  }
}
}

