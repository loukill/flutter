import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/text.dart';

class StatisticBarChart extends StatelessWidget {
  final List<Texte> textes;

  StatisticBarChart({Key? key, required this.textes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = _createBarGroups(context);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < textes.length) {
                  String title = textes[index].title;
                  // Raccourcir le titre si nécessaire
                  if (title.length > 10) {
                    title = title.substring(0, 10) + '...';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Transform.rotate(
                      angle: -45 * (3.14 / 180), // Rotation de 45 degrés
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  );
                }
                return Container();
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(BuildContext context) {
    return List.generate(textes.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: textes[index].consultationsCount.toDouble(),
            rodStackItems: [
              BarChartRodStackItem(
                0,
                textes[index].consultationsCount.toDouble(),
                Theme.of(context).primaryColor,
              ),
            ],
            width: 10,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}