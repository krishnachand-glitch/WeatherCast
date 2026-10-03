import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/core/utils/uv_utils.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/providers/settings_provider.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';

class WeatherDetailsGrid extends ConsumerWidget {
  final CurrentWeather currentWeather;
  final DailyWeather todayDaily;

  const WeatherDetailsGrid({
    Key? key,
    required this.currentWeather,
    required this.todayDaily,
  }) : super(key: key);

  String _formatTemp(double celsius, TemperatureUnit unit) {
    if (unit == TemperatureUnit.fahrenheit) {
      return '${WeatherUtils.celsiusToFahrenheit(celsius).round()}°';
    } else if (unit == TemperatureUnit.kelvin) {
      return '${WeatherUtils.celsiusToKelvin(celsius).round()}';
    }
    return '${celsius.round()}°';
  }

  String _formatWind(double speedKmh, WindUnit unit) {
    if (unit == WindUnit.mph) {
      return '${(speedKmh * 0.621371).round()} mph';
    } else if (unit == WindUnit.ms) {
      return '${(speedKmh * 0.277778).round()} m/s';
    }
    return '${speedKmh.round()} km/h';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _buildDetailCard(
          icon: Icons.water_drop,
          value: '${currentWeather.relativeHumidity}%',
          label: 'Humidity',
        ),
        _buildDetailCard(
          icon: Icons.air,
          value: _formatWind(currentWeather.windSpeed, settings.windUnit),
          label: WeatherUtils.getWindDirection(currentWeather.windDirection),
        ),
        _buildDetailCard(
          icon: Icons.wb_sunny,
          value: currentWeather.uvIndex.toStringAsFixed(1),
          label: UvUtils.getUvLevel(currentWeather.uvIndex),
          valueColor: UvUtils.getUvColor(currentWeather.uvIndex),
        ),
        _buildDetailCard(
          icon: Icons.visibility,
          value: '${(currentWeather.visibility / 1000).toStringAsFixed(1)} km',
          label: 'Visibility',
        ),
        _buildDetailCard(
          icon: Icons.thermostat,
          value: '${currentWeather.pressure.round()} hPa',
          label: 'Pressure',
        ),
        _buildDetailCard(
          icon: Icons.device_thermostat,
          value: _formatTemp(currentWeather.apparentTemperature, settings.temperatureUnit),
          label: 'Feels Like',
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String value,
    required String label,
    Color? valueColor,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 28),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: valueColor ?? Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white60,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
