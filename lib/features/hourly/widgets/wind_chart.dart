import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/services/storage_service.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';

class WindChart extends StatelessWidget {
  final List<HourlyWeather> hourlyData;
  final WindUnit windUnit;

  const WindChart({
    super.key,
    required this.hourlyData,
    required this.windUnit,
  });

  @override
  Widget build(BuildContext context) {
    final displayData = hourlyData.take(24).toList();
    if (displayData.isEmpty) return const SizedBox();

    double minSpeed = double.infinity;
    double maxSpeed = double.negativeInfinity;
    final spots = <FlSpot>[];

    for (int i = 0; i < displayData.length; i++) {
      double speed = displayData[i].windSpeed;
      if (windUnit == WindUnit.mph) {
        speed = WeatherUtils.kmhToMph(speed);
      } else if (windUnit == WindUnit.ms) {
        speed = WeatherUtils.kmhToMs(speed);
      } else if (windUnit == WindUnit.knots) {
        speed = WeatherUtils.kmhToKnots(speed);
      }
      
      if (speed < minSpeed) minSpeed = speed;
      if (speed > maxSpeed) maxSpeed = speed;
      spots.add(FlSpot(i.toDouble(), speed));
    }

    final double buffer = (maxSpeed - minSpeed).abs() * 0.2 + 2;
    final double minY = (minSpeed - buffer) < 0 ? 0 : (minSpeed - buffer);
    final double maxY = maxSpeed + buffer;

    return LineChart(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 3,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
          getDrawingVerticalLine: (value) => FlLine(
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
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  textAlign: TextAlign.center,
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (displayData.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.tealAccent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.tealAccent.withOpacity(0.5),
                  Colors.tealAccent.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final time = displayData[spot.x.toInt()].time;
                final timeStr = DateFormat('h a').format(time);
                final unitStr = windUnit.name.toUpperCase();
                return LineTooltipItem(
                  '$timeStr\n${spot.y.toStringAsFixed(1)} $unitStr',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
