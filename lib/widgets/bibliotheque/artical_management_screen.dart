import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/artical_model.dart';
import 'package:flutter_dashboard/services/artical_service.dart';

import 'package:flutter_dashboard/widgets/bibliotheque/artical_form.dart';

class ArticleManagementScreen extends StatefulWidget {
  const ArticleManagementScreen({Key? key, required List articles, required List articlers}) : super(key: key);

  @override
  _ArticleManagementScreenState createState() => _ArticleManagementScreenState();
}

class _ArticleManagementScreenState extends State<ArticleManagementScreen> {
  List<ArticleModel> articles = [];
  List<ArticleModel> filteredArticles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      articles = await ArticleService.fetchArticles();
      setState(() {
        filteredArticles = articles;
      });
    } catch (e) {
      print('Error loading articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPublishedArticles = articles.length;

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
                  filteredArticles = articles
                      .where((article) =>
                          article.title.toLowerCase().contains(value.toLowerCase()))
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
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('PDF')),
              DataColumn(label: Text('Actions')),
            ],
            rows: filteredArticles.map(
              (article) => DataRow(cells: [
                DataCell(Text(article.id.toString())),
                DataCell(Text(article.title)),
                DataCell(Text(article.author)),
                DataCell(Text(article.date)),
                DataCell(
                  article.image != null
                      ? Image.file(article.image!, height: 50)
                      : const Text('No Image'),
                ),
                DataCell(
                  Text(article.pdf != null ? 'PDF disponible' : 'Aucun PDF'),
                ),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleForm(article: article),
                          ),
                        );

                        if (result != null && result is ArticleModel) {
                          await _updateArticle(result);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _deleteArticle(article.id);
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
              Text('Total d\'articles publiés: $totalPublishedArticles'),
              FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArticleForm(),
                    ),
                  );

                  if (result != null && result is ArticleModel) {
                    await _addArticle(result);
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

  Future<void> _addArticle(ArticleModel article) async {
    try {
      await ArticleService.addArticle(article);
      _loadArticles();
    } catch (e) {
      print('Error adding article: $e');
    }
  }

  Future<void> _updateArticle(ArticleModel article) async {
    try {
      await ArticleService.updateArticle(article);
      _loadArticles();
    } catch (e) {
      print('Error updating article: $e');
    }
  }

  Future<void> _deleteArticle(int articleId) async {
    try {
      await ArticleService.deleteArticle(articleId);
      _loadArticles();
    } catch (e) {
      print('Error deleting article: $e');
    }
  }
}