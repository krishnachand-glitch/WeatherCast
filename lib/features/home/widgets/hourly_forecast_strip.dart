import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/weather_icon_mapper.dart';

class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyWeather> hourlyList;
  final TemperatureUnit tempUnit;
  final bool isDay;

  const HourlyForecastStrip({
    Key? key,
    required this.hourlyList,
    required this.tempUnit,
    required this.isDay,
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
    final now = DateTime.now();
    // Filter to upcoming 24 hours
    final upcomingHourly = hourlyList.where((h) => h.time.isAfter(now.subtract(const Duration(hours: 1)))).take(24).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              'HOURLY FORECAST',
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
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: upcomingHourly.length,
            itemBuilder: (context, index) {
              final hourly = upcomingHourly[index];
              final bool isCurrentHour = index == 0;
              final timeString = isCurrentHour ? 'Now' : DateFormat('h a').format(hourly.time);
              
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  opacity: isCurrentHour ? 0.3 : 0.15,
                  child: SizedBox(
                    width: 55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeString,
                          style: GoogleFonts.inter(
                            color: isCurrentHour ? Colors.white : Colors.white70,
                            fontSize: 13,
                            fontWeight: isCurrentHour ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        WeatherIconWidget(
                          weatherCode: hourly.weatherCode,
                          isDay: isDay, // Usually derived per hour, but we pass day/night for simplicity or adapt here
                          size: 30,
                        ),
                        Text(
                          _formatTemp(hourly.temperature),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (hourly.precipitationProbability > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.water_drop, color: Colors.lightBlueAccent, size: 10),
                              Text(
                                '${hourly.precipitationProbability.round()}%',
                                style: GoogleFonts.inter(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
