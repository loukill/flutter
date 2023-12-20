import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/text.dart';
import 'package:flutter_dashboard/model/text_consultation.dart';
import 'package:flutter_dashboard/pages/category/widgets/text_edit_page.dart';
import 'package:flutter_dashboard/services/api_service.dart';
import 'package:flutter_dashboard/widgets/category/statistic_bar_chart.dart';

class TextFilesWidget extends StatefulWidget {
  @override
  _TextFilesWidgetState createState() => _TextFilesWidgetState();
}

class _TextFilesWidgetState extends State<TextFilesWidget> {
  late ApiService apiService;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fichiers Texte'),
      ),
      body: Row(children: [
        Expanded(
          flex:
              2, // Ajustez ce paramètre selon la taille souhaitée du graphique dans le layout
          child: Padding(
            padding: const EdgeInsets.all(10), // Espace autour du graphique
            child: FutureBuilder<List<Texte>>(
              future: apiService.getAllTextes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StatisticBarChart(textes: snapshot.data!),
                    ),
                  );
                } else {
                  return Center(child: Text('Aucun texte trouvé'));
                }
              },
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child: FutureBuilder<List<Texte>>(
              future: apiService.getAllTextes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun texte trouvé'));
                } else {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey),
                    itemBuilder: (context, index) {
                      var texte = snapshot.data![index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            texte.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                            // Afficher le contenu complet du texte dans un AlertDialog, par exemple
                          },
                        ),
                      );
                    },
                  );
                }
              },
            )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logique pour le bouton 'Plus' ici
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
