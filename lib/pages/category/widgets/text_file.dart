import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/text.dart';
import 'package:flutter_dashboard/model/text_consultation.dart';
import 'package:flutter_dashboard/pages/category/widgets/new_text_page.dart';
import 'package:flutter_dashboard/pages/category/widgets/text_edit_page.dart';
import 'package:flutter_dashboard/pages/home/widgets/text_search.dart';
import 'package:flutter_dashboard/services/api_service.dart';
import 'package:flutter_dashboard/widgets/category/statistic_bar_chart.dart';

class TextFilesWidget extends StatefulWidget {
  @override
  _TextFilesWidgetState createState() => _TextFilesWidgetState();
}

class _TextFilesWidgetState extends State<TextFilesWidget> {
  late ApiService apiService;
  TextEditingController searchController = TextEditingController();
  List<Texte> allTextes = [];
  List<Texte> filteredTextes = [];

  Future<List<BarChartGroupData>> _getBarGroups() async {
    List<TextConsultation> consultations =
        await apiService.getTextConsultations();

    return consultations.asMap().entries.map((entry) {
      int index = entry.key;
      TextConsultation consultation = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: consultation.consultationsCount.toDouble())
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    apiService = ApiService('http://localhost:3000');
    _loadTextes();
  }

  void _loadTextes() async {
    var texts = await apiService.getAllTextes();
    setState(() {
      allTextes = texts;
      filteredTextes = texts;
    });
  }

  void _searchText(String query) {
    var filteredList = allTextes.where((texte) {
      return texte.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredTextes = filteredList;
    });
  }

  String getExcerpt(String content, {int maxLength = 100}) {
    return (content.length <= maxLength)
        ? content
        : '${content.substring(0, maxLength)}...';
  }

  void _confirmDelete(String texteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce texte ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () {
                _deleteTexte(texteId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTexte(String texteId) async {
    try {
      await apiService.deleteTexte(texteId);
      setState(() {
        // Vous devriez rafraîchir la liste des textes ici.
      });
    } catch (e) {
      // Gérer l'erreur
    }
  }

  void _updateTexte(String texteId, Texte currentTexte) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => TextEditPage(
          texteId: texteId,
          currentTexte: currentTexte,
          apiService: apiService, // Passage de l'instance
        ),
      ),
    )
        .then((_) {
      setState(() {
        // Recharger la liste des textes pour afficher les mises à jour
      });
    });
  }

  void _addNewText() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => NewTextPage(apiService: apiService),
      ),
    )
        .then((_) {
      setState(() {
        // Recharger la liste des textes après l'ajout
      });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Fichiers Texte'),
    ),
    body: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Recherche',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _searchText,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchText(searchController.text),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2, // Taille du graphique
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: FutureBuilder<List<Texte>>(
                        future: apiService.getAllTextes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Erreur: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return StatisticBarChart(textes: snapshot.data!); // Assurez-vous que snapshot.data est une List<Texte>
                          } else {
                            return Center(child: Text('Aucune donnée disponible'));
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3, // Taille de la liste de textes
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 80),
                    child: ListView.separated(
                      itemCount: filteredTextes.length,
                      separatorBuilder: (context, index) => Divider(color: Colors.grey),
                      itemBuilder: (context, index) {
                        var texte = filteredTextes[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(
                              texte.title,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(getExcerpt(texte.content)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _updateTexte(texte.id, texte),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(texte.id),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Action lors du tap sur un élément
                            },
                          ),
                        );
                      },
                    ),
                  )
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: _addNewText,
            child: Icon(Icons.add),
          ),
        ),
      ],
    ),
  );
}
}