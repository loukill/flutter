import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/responsive.dart';
import 'package:flutter_dashboard/widgets/custom_card.dart';
import 'package:intl/intl.dart';

class LineChartSimon extends StatelessWidget {
  final List<FlSpot> spots;
  final Map<double, String> leftTitle;
  final Map<double, String> bottomTitle;
  final double minX, maxX, minY, maxY;
  final DateTime startDate; // Ajoutez cette ligne

  LineChartSimon({
    super.key,
    required this.spots,
    required this.leftTitle,
    required this.bottomTitle,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.startDate, // Ajoutez cette ligne
  });

  @override
  Widget build(BuildContext context) {
    // Déterminez l'intervalle en fonction de la plage de dates
    final interval = maxX / 3; // Ajustez ici pour changer l'espacement

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Scores Simon Dit Overview",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: Responsive.isMobile(context) ? 9 / 4 : 16 / 6,
            child: LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(handleBuiltInTouches: true),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1, // Afficher une étiquette pour chaque jour
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final DateTime date =
                            startDate.add(Duration(days: value.toInt()));
                        final String dateString = DateFormat('d MMM').format(
                            date); // Format pour afficher le jour et le mois
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0), // Ajuster selon le besoin
                          child: Text(
                            dateString,
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context) ? 10 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final String text = leftTitle[value] ?? '';
                        return Text(
                          text,
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context) ? 9 : 12,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                      interval: 1,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0,
                    color: Theme.of(context).primaryColor,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    dotData: FlDotData(show: false),
                    spots: spots,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
