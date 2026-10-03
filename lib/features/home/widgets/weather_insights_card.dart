import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/data/models/air_quality_data.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';

class WeatherInsight {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  WeatherInsight({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class WeatherInsightsCard extends StatelessWidget {
  final WeatherData weatherData;
  final AirQualityData? airQualityData;

  const WeatherInsightsCard({
    Key? key,
    required this.weatherData,
    this.airQualityData,
  }) : super(key: key);

  List<WeatherInsight> _generateInsights() {
    List<WeatherInsight> insights = [];
    final current = weatherData.current;
    final today = weatherData.daily.first;
    final now = DateTime.now();

    // 1. Rain check
    final upcomingRain = weatherData.hourly.where((h) => h.time.isAfter(now) && h.time.isBefore(now.add(const Duration(hours: 12))) && h.precipitationProbability > 70).toList();
    if (upcomingRain.isNotEmpty) {
      insights.add(WeatherInsight(
        icon: Icons.umbrella,
        title: 'Rain Expected',
        description: 'Bring an umbrella, rain expected starting around ${DateFormat('h a').format(upcomingRain.first.time)}.',
        color: Colors.blueAccent,
      ));
    }

    // 2. UV check
    if (current.uvIndex > 6) {
      insights.add(WeatherInsight(
        icon: Icons.wb_sunny,
        title: 'High UV Index',
        description: 'UV index is ${current.uvIndex}. Wear sunscreen if you are going outside.',
        color: Colors.orangeAccent,
      ));
    }

    // 3. Wind check
    if (today.windSpeed10mMax > 40) {
      insights.add(WeatherInsight(
        icon: Icons.air,
        title: 'Strong Winds',
        description: 'Wind gusts up to ${today.windSpeed10mMax.round()} km/h today.',
        color: Colors.cyanAccent,
      ));
    }

    // 4. Heat check
    if (today.temperatureMax > 35) {
      insights.add(WeatherInsight(
        icon: Icons.local_fire_department,
        title: 'Extreme Heat',
        description: 'Temperatures will reach ${today.temperatureMax.round()}°C today. Stay hydrated.',
        color: Colors.redAccent,
      ));
    }

    // 5. Cold check
    if (today.temperatureMin < 5) {
      insights.add(WeatherInsight(
        icon: Icons.ac_unit,
        title: 'Freezing Temperatures',
        description: 'Temperatures dropping to ${today.temperatureMin.round()}°C. Bundle up!',
        color: Colors.lightBlue,
      ));
    }

    // 6. AQI check
    if (airQualityData != null && airQualityData!.current.europeanAqi > 75) {
      insights.add(WeatherInsight(
        icon: Icons.masks,
        title: 'Poor Air Quality',
        description: 'AQI is ${airQualityData!.current.europeanAqi}. Sensitive groups should limit outdoor exertion.',
        color: Colors.deepPurpleAccent,
      ));
    }

    // 7. Perfect weather
    if (current.weatherCode == 0 && current.uvIndex < 4 && current.windSpeed < 20 && insights.isEmpty) {
      insights.add(WeatherInsight(
        icon: Icons.directions_walk,
        title: 'Perfect Outdoors',
        description: 'Great conditions for a walk or outdoor activities today.',
        color: Colors.greenAccent,
      ));
    }

    // 9. No rain expected
    if (today.precipitationProbabilityMax < 20 && insights.isEmpty) {
      insights.add(WeatherInsight(
        icon: Icons.wb_sunny_outlined,
        title: 'Clear Skies',
        description: 'No rain expected today. Enjoy the clear weather.',
        color: Colors.yellowAccent,
      ));
    }

    return insights.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights();
    if (insights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.psychology, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              '🧠 WEATHER INTELLIGENCE',
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(insights.length, (index) {
              final insight = insights[index];
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: insight.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(insight.icon, color: insight.color, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insight.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              insight.description,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (index < insights.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
