import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/services/storage_service.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/gradient_scaffold.dart';
import 'package:weathercast_pro/widgets/weather_icon_widget.dart';
import 'package:weathercast_pro/features/hourly/widgets/temperature_chart.dart';
import 'package:weathercast_pro/features/hourly/widgets/rain_chart.dart';
import 'package:weathercast_pro/features/hourly/widgets/wind_chart.dart';

class HourlyDetailScreen extends ConsumerWidget {
  final List<HourlyWeather> hourlyData;
  final TemperatureUnit temperatureUnit;
  final WindUnit windUnit;
  final WeatherCode currentWeatherCode;

  const HourlyDetailScreen({
    super.key,
    required this.hourlyData,
    required this.temperatureUnit,
    required this.windUnit,
    required this.currentWeatherCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: GradientScaffold(
        weatherCode: currentWeatherCode,
        appBar: AppBar(
          title: const Text('Hourly Forecast'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Temperature'),
              Tab(text: 'Rain'),
              Tab(text: 'Wind'),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TemperatureChart(
                      hourlyData: hourlyData,
                      temperatureUnit: temperatureUnit,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RainChart(
                      hourlyData: hourlyData,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: WindChart(
                      hourlyData: hourlyData,
                      windUnit: windUnit,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GlassCard(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: hourlyData.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white24,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final data = hourlyData[index];
                      final timeFormat = DateFormat('h a');
                      
                      double temp = data.temperature;
                      if (temperatureUnit == TemperatureUnit.fahrenheit) {
                        temp = WeatherUtils.celsiusToFahrenheit(temp);
                      } else if (temperatureUnit == TemperatureUnit.kelvin) {
                        temp = WeatherUtils.celsiusToKelvin(temp);
                      }

                      double windSpeed = data.windSpeed;
                      if (windUnit == WindUnit.mph) {
                        windSpeed = WeatherUtils.kmhToMph(windSpeed);
                      } else if (windUnit == WindUnit.ms) {
                        windSpeed = WeatherUtils.kmhToMs(windSpeed);
                      } else if (windUnit == WindUnit.knots) {
                        windSpeed = WeatherUtils.kmhToKnots(windSpeed);
                      }

                      final String tempString = '${temp.round()}°';
                      final String windString = '${windSpeed.round()}';
                      final String windUnitString = windUnit.name.toUpperCase();

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: index.isEven ? Colors.white.withOpacity(0.05) : Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                timeFormat.format(data.time),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            WeatherIconWidget(
                              weatherCode: data.weatherCode,
                              size: 30,
                              isDay: data.time.hour >= 6 && data.time.hour <= 18,
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                tempString,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.water_drop, color: Colors.blueAccent, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${data.precipitationProbability}%',
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.air, color: Colors.tealAccent, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$windString $windUnitString',
                                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
