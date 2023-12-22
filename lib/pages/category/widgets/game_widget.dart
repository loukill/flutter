import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/score_data.dart';
import 'package:flutter_dashboard/model/score_tic_tac.dart';
import 'package:flutter_dashboard/pages/home/widgets/bar_chart_tic_tac.dart';
import 'package:flutter_dashboard/pages/home/widgets/line_chart_simon.dart';
import 'package:flutter_dashboard/services/api_service.dart';
import 'package:intl/intl.dart'; // Importez votre widget LineChartSimon

class GamesWidget extends StatefulWidget {
  @override
  _GamesWidgetState createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  late Future<List<ScoreData>> futureScores;
  late Future<List<ScoreTicTac>> futureTicTacScores;
  DateTime startDate = DateTime(2023, 12, 15);
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService('http://localhost:3000');
    futureScores = apiService.getScores(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<ScoreData>>(
              future: futureScores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur de chargement des scores de Simon Dit');
                } else if (snapshot.hasData) {
                  // Traitement des données pour LineChartSimon
                  var sortedScores = snapshot.data!;
                  sortedScores.sort((a, b) => a.date.compareTo(b.date));

                  double minX = 0;
                  double maxX = sortedScores.last.date
                      .difference(startDate)
                      .inDays
                      .toDouble();

                  double minY =
                      sortedScores.map((e) => e.score.toDouble()).reduce(min);
                  double maxY =
                      sortedScores.map((e) => e.score.toDouble()).reduce(max);

                  Map<double, String> leftTitles = {
                    minY: minY.toString(),
                    maxY: maxY.toString(),
                  };

                  Map<double, String> bottomTitles = {};
                  for (var data in sortedScores) {
                    final daysSinceStart =
                        data.date.difference(startDate).inDays.toDouble();
                    bottomTitles[daysSinceStart] =
                        DateFormat('MMM d').format(data.date);
                  }

                  List<FlSpot> spots = sortedScores.map((scoreData) {
                    final daysSinceStart =
                        scoreData.date.difference(startDate).inDays.toDouble();
                    final scoreDouble = scoreData.score.toDouble();
                    return FlSpot(daysSinceStart, scoreDouble);
                  }).toList();

                  return LineChartSimon(
                    spots: spots,
                    leftTitle: leftTitles,
                    bottomTitle: bottomTitles,
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                    startDate: startDate,
                  );
                } else {
                  return Text('Aucun score de Simon Dit disponible');
                }
              },
            ),// Espacement entre les graphiques
          ],
        ),
      ),
    );
  }
}
