import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';

class RainChart extends StatelessWidget {
  final List<HourlyWeather> hourlyData;

  const RainChart({
    super.key,
    required this.hourlyData,
  });

  @override
  Widget build(BuildContext context) {
    final displayData = hourlyData.take(24).toList();
    if (displayData.isEmpty) return const SizedBox();

    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < displayData.length; i++) {
      final data = displayData[i];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data.precipitationProbability.toDouble(),
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF4FC3F7)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 12,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 100,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
      );
    }

    return BarChart(
      swapAnimationDuration: const Duration(milliseconds: 1500),
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= displayData.length) return const SizedBox.shrink();
                final time = displayData[index].time;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('h a').format(time),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  textAlign: TextAlign.center,
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
        barGroups: barGroups,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final time = displayData[group.x].time;
              final timeStr = DateFormat('h a').format(time);
              return BarTooltipItem(
                '$timeStr\n${rod.toY.toInt()}%',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
    );
  }
}
