import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/services/storage_service.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/gradient_scaffold.dart';
import 'package:weathercast_pro/widgets/weather_icon_widget.dart';
import 'package:weathercast_pro/features/hourly/widgets/temperature_chart.dart';

class DailyDetailScreen extends StatelessWidget {
  final DailyWeather dailyData;
  final List<HourlyWeather> hourlyData;
  final TemperatureUnit temperatureUnit;
  final WindUnit windUnit;

  const DailyDetailScreen({
    super.key,
    required this.dailyData,
    required this.hourlyData,
    required this.temperatureUnit,
    required this.windUnit,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('h:mm a');

    double maxTemp = dailyData.temperatureMax;
    double minTemp = dailyData.temperatureMin;
    double apparentMax = dailyData.apparentTemperatureMax;
    
    if (temperatureUnit == TemperatureUnit.fahrenheit) {
      maxTemp = WeatherUtils.celsiusToFahrenheit(maxTemp);
      minTemp = WeatherUtils.celsiusToFahrenheit(minTemp);
      apparentMax = WeatherUtils.celsiusToFahrenheit(apparentMax);
    } else if (temperatureUnit == TemperatureUnit.kelvin) {
      maxTemp = WeatherUtils.celsiusToKelvin(maxTemp);
      minTemp = WeatherUtils.celsiusToKelvin(minTemp);
      apparentMax = WeatherUtils.celsiusToKelvin(apparentMax);
    }

    double windSpeed = dailyData.windSpeedMax;
    if (windUnit == WindUnit.mph) {
      windSpeed = WeatherUtils.kmhToMph(windSpeed);
    } else if (windUnit == WindUnit.ms) {
      windSpeed = WeatherUtils.kmhToMs(windSpeed);
    } else if (windUnit == WindUnit.knots) {
      windSpeed = WeatherUtils.kmhToKnots(windSpeed);
    }

    final String tempUnitStr = temperatureUnit == TemperatureUnit.fahrenheit ? '°F' : (temperatureUnit == TemperatureUnit.kelvin ? 'K' : '°C');
    final String windUnitStr = windUnit.name.toUpperCase();

    return GradientScaffold(
      weatherCode: dailyData.weatherCode,
      appBar: AppBar(
        title: Text(dateFormat.format(dailyData.time)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            WeatherIconWidget(
              weatherCode: dailyData.weatherCode,
              size: 100,
              isDay: true,
            ),
            const SizedBox(height: 16),
            Text(
              WeatherUtils.getWeatherDescription(dailyData.weatherCode),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${maxTemp.round()}°',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${minTemp.round()}°',
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildDetailCard('Feels Like', '${apparentMax.round()}$tempUnitStr', Icons.thermostat),
                _buildDetailCard('Rain', '${dailyData.precipitationProbabilityMax}%\n${dailyData.precipitationSum}mm', Icons.water_drop),
                _buildDetailCard('Max Wind', '${windSpeed.round()} $windUnitStr', Icons.air),
                _buildDetailCard('UV Index', '${dailyData.uvIndexMax}', Icons.wb_sunny),
                _buildDetailCard('Sunrise', timeFormat.format(dailyData.sunrise), Icons.wb_twilight),
                _buildDetailCard('Sunset', timeFormat.format(dailyData.sunset), Icons.nights_stay),
              ],
            ),
            const SizedBox(height: 32),
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hourly Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: TemperatureChart(
                        hourlyData: hourlyData,
                        temperatureUnit: temperatureUnit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
