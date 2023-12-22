import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/score_tic_tac.dart';

class BarChartTicTac extends StatefulWidget {
  final List<ScoreTicTac> scores;

  const BarChartTicTac({Key? key, required this.scores}) : super(key: key);

  @override
  _BarChartTicTacState createState() => _BarChartTicTacState();
}

class _BarChartTicTacState extends State<BarChartTicTac> {
  @override
  Widget build(BuildContext context) {
    double maxY = widget.scores.map((e) => e.score).reduce(max) * 1.1;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.all(16), 
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.blueGrey,
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    rod.toY.round().toString(),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: _getTitlesWidget,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: widget.scores.asMap().entries.map((entry) {
              return makeGroupData(entry.key, entry.value.score);
            }).toList(),
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: _getBarColor(y),
          borderRadius: BorderRadius.circular(4),
          width: 16,
        ),
      ],
    );
  }

  Color _getBarColor(double score) {
    if (score >= 30) {
      return Colors.green[300]!;
    } else if (score >= 15) {
      return Colors.orange[300]!;
    } else {
      return Colors.red[300]!;
    }
  }

  Widget _getTitlesWidget(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff939393),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
  int index = value.toInt();
  if (index >= 0 && index < widget.scores.length) {
    text = widget.scores[index].username;
  } else {
    text = '';
  }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(text, style: style),
    );
  }
}
