import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/text_content.dart';
import 'package:flutter_dashboard/model/text_statistic.dart';
import 'package:flutter_dashboard/model/text_title.dart';
import 'package:flutter_dashboard/services/api_service.dart';

class TextFilesWidget extends StatefulWidget {
  @override
  _TextFilesWidgetState createState() => _TextFilesWidgetState();
}

class _TextFilesWidgetState extends State<TextFilesWidget> {
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService('http://localhost:3000');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fichiers Texte'),
      ),
      body: FutureBuilder<List<TextTitle>>(
        future: apiService.fetchTitles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                var title = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () async {
                      TextContent content = await apiService.fetchText(title.id);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(title.title),
                            content: SingleChildScrollView(
                              child: Text(content.content),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                         FutureBuilder<List<TextStatistics>>(
                            future: apiService.fetchStatistics(title.id),
                            builder: (context, statisticsSnapshot) {
                               if (statisticsSnapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Chargement des statistiques...');
                                } else if (statisticsSnapshot.hasError) {
                                  return Text('Erreur de chargement des statistiques');
                                } else {
                                  final statistics = statisticsSnapshot.data?.firstOrNull;
                                  return Text(
                                    'Consultations: ${statistics?.consultations ?? 0}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  );
                                }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
