import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/score_tic_tac.dart';
import 'package:flutter_dashboard/pages/home/widgets/bar_chart_tic_tac.dart';
import 'package:flutter_dashboard/services/api_service.dart';

class TicTacScoresWidget extends StatefulWidget {
  @override
  _TicTacScoresWidgetState createState() => _TicTacScoresWidgetState();
}

class _TicTacScoresWidgetState extends State<TicTacScoresWidget> {
  late Future<List<ScoreTicTac>> futureTicTacScores;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService('http://localhost:3000');
    futureTicTacScores = apiService.fetchScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores Tic Tac Toe'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<ScoreTicTac>>(
            future: futureTicTacScores,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: BarChartTicTac(scores: snapshot.data!),
                      )
                    : Text('Aucun score de Tic Tac Toe disponible');
              } else {
                return Text('Chargement des scores de Tic Tac Toe...');
              }
            },
          ),
        ),
      ),
    );
  }
}
