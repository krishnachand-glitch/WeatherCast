import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/widgets/weather_icon_mapper.dart';

class WeatherHero extends StatelessWidget {
  final CurrentWeather currentWeather;
  final DailyWeather dailyWeather;
  final String cityName;
  final TemperatureUnit tempUnit;

  const WeatherHero({
    Key? key,
    required this.currentWeather,
    required this.dailyWeather,
    required this.cityName,
    required this.tempUnit,
  }) : super(key: key);

  String _formatTemp(double celsius) {
    if (tempUnit == TemperatureUnit.fahrenheit) {
      return '${WeatherUtils.celsiusToFahrenheit(celsius).round()}°F';
    } else if (tempUnit == TemperatureUnit.kelvin) {
      return '${WeatherUtils.celsiusToKelvin(celsius).round()}K';
    }
    return '${celsius.round()}°C';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDay = WeatherUtils.isDay(dailyWeather.sunrise, dailyWeather.sunset, DateTime.now());
    
    return Column(
      children: [
        WeatherIconWidget(
          weatherCode: currentWeather.weatherCode,
          isDay: isDay,
          size: 60,
        ),
        const SizedBox(height: 16),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: currentWeather.temperature),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            String displayedTemp = tempUnit == TemperatureUnit.fahrenheit 
              ? '${WeatherUtils.celsiusToFahrenheit(value).round()}°F' 
              : tempUnit == TemperatureUnit.kelvin 
                ? '${WeatherUtils.celsiusToKelvin(value).round()}K' 
                : '${value.round()}°C';
                
            return Text(
              displayedTemp,
              style: GoogleFonts.poppins(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
            );
          },
        ),
        Text(
          WeatherUtils.getConditionText(currentWeather.weatherCode),
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            shadows: [const Shadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Feels like ${_formatTemp(currentWeather.apparentTemperature)}',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'H:${_formatTemp(dailyWeather.temperatureMax)}',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 16),
            Text(
              'L:${_formatTemp(dailyWeather.temperatureMin)}',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
