import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/weather_icon_mapper.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyWeather> dailyList;
  final TemperatureUnit tempUnit;

  const DailyForecastList({
    Key? key,
    required this.dailyList,
    required this.tempUnit,
  }) : super(key: key);

  String _formatTemp(double celsius) {
    if (tempUnit == TemperatureUnit.fahrenheit) {
      return '${WeatherUtils.celsiusToFahrenheit(celsius).round()}°';
    } else if (tempUnit == TemperatureUnit.kelvin) {
      return '${WeatherUtils.celsiusToKelvin(celsius).round()}';
    }
    return '${celsius.round()}°';
  }

  @override
  Widget build(BuildContext context) {
    if (dailyList.isEmpty) return const SizedBox.shrink();
    
    // Find absolute min and max for the whole week to scale the gradient bar
    double weeklyMin = dailyList.map((d) => d.temperatureMin).reduce((a, b) => a < b ? a : b);
    double weeklyMax = dailyList.map((d) => d.temperatureMax).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              '7-DAY FORECAST',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: List.generate(dailyList.length, (index) {
              final daily = dailyList[index];
              final isToday = index == 0;
              final dayString = isToday ? 'Today' : DateFormat('EEE').format(daily.date);

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigate to daily detail screen
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              dayString,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          WeatherIconWidget(
                            weatherCode: daily.weatherCode,
                            isDay: true,
                            size: 28,
                          ),
                          SizedBox(
                            width: 50,
                            child: daily.precipitationProbabilityMax > 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.water_drop, color: Colors.lightBlueAccent, size: 12),
                                      Text(
                                        '${daily.precipitationProbabilityMax.round()}%',
                                        style: GoogleFonts.inter(color: Colors.lightBlueAccent, fontSize: 12),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Text(
                            _formatTemp(daily.temperatureMin),
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTemperatureBar(
                              daily.temperatureMin,
                              daily.temperatureMax,
                              weeklyMin,
                              weeklyMax,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTemp(daily.temperatureMax),
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index < dailyList.length - 1)
                    const Divider(color: Colors.white10, height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureBar(double minTemp, double maxTemp, double weeklyMin, double weeklyMax) {
    final range = weeklyMax - weeklyMin;
    final startFraction = (minTemp - weeklyMin) / range;
    final widthFraction = (maxTemp - minTemp) / range;

    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFraction.clamp(0.0, 1.0),
        child: Container(
          margin: EdgeInsets.only(left: (startFraction * 100).clamp(0.0, 100.0) * 1.0), // rough approximation for layout
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.orangeAccent],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
