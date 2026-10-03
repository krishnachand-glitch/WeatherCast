import 'package:flutter/material.dart';
import 'weather_data.dart';
import 'air_quality_data.dart';
import '../../core/constants/app_colors.dart';

enum AlertSeverity { low, moderate, high, extreme }

enum AlertType {
  heavyRain,
  storm,
  heatwave,
  coldWave,
  highWind,
  poorAqi,
  highUv,
  flooding;

  String get displayName {
    switch (this) {
      case AlertType.heavyRain: return 'Heavy Rain Alert';
      case AlertType.storm: return 'Storm Alert';
      case AlertType.heatwave: return 'Heatwave Warning';
      case AlertType.coldWave: return 'Cold Wave Warning';
      case AlertType.highWind: return 'High Wind Warning';
      case AlertType.poorAqi: return 'Poor Air Quality';
      case AlertType.highUv: return 'Extreme UV Alert';
      case AlertType.flooding: return 'Flooding Warning';
    }
  }

  IconData get icon {
    switch (this) {
      case AlertType.heavyRain: return Icons.water_drop;
      case AlertType.storm: return Icons.flash_on;
      case AlertType.heatwave: return Icons.thermostat;
      case AlertType.coldWave: return Icons.ac_unit;
      case AlertType.highWind: return Icons.air;
      case AlertType.poorAqi: return Icons.masks;
      case AlertType.highUv: return Icons.wb_sunny;
      case AlertType.flooding: return Icons.flood;
    }
  }
}

class WeatherAlert {
  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertType type;
  final DateTime startTime;
  final DateTime endTime;
  final String safetyGuidance;

  WeatherAlert({
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.safetyGuidance,
  });

  Color get severityColor {
    switch (severity) {
      case AlertSeverity.low: return Colors.green;
      case AlertSeverity.moderate: return Colors.orange;
      case AlertSeverity.high: return Colors.deepOrange;
      case AlertSeverity.extreme: return Colors.red;
    }
  }

  IconData get icon => type.icon;

  static List<WeatherAlert> generateAlerts(WeatherData weather, AirQualityData? airQuality) {
    final List<WeatherAlert> alerts = [];
    final current = weather.current;
    final now = DateTime.now();
    final endTime = now.add(const Duration(hours: 4));

    if (current.windSpeed > 50) {
      alerts.add(WeatherAlert(
        title: 'High Wind Warning',
        description: 'Winds are exceeding 50 km/h.',
        severity: current.windSpeed > 80 ? AlertSeverity.extreme : AlertSeverity.high,
        type: AlertType.highWind,
        startTime: now,
        endTime: endTime,
        safetyGuidance: 'Secure loose outdoor objects. Avoid standing under trees.',
      ));
    }

    if (weather.hourly.isNotEmpty) {
      final nextHour = weather.hourly.first;
      if (nextHour.precipitationProbability > 80 && nextHour.precipitation > 10) {
        alerts.add(WeatherAlert(
          title: 'Heavy Rain Alert',
          description: 'Heavy precipitation expected shortly.',
          severity: AlertSeverity.high,
          type: AlertType.heavyRain,
          startTime: now,
          endTime: endTime,
          safetyGuidance: 'Seek shelter. Be cautious of potential localized flooding.',
        ));
      }
    }

    if (current.uvIndex > 8) {
      alerts.add(WeatherAlert(
        title: 'Extreme UV Alert',
        description: 'UV Index is extremely high (${current.uvIndex}).',
        severity: current.uvIndex > 10 ? AlertSeverity.extreme : AlertSeverity.high,
        type: AlertType.highUv,
        startTime: now,
        endTime: endTime,
        safetyGuidance: 'Avoid prolonged sun exposure. Wear protective clothing and sunscreen.',
      ));
    }

    if (current.temperature > 40) {
      alerts.add(WeatherAlert(
        title: 'Heatwave Warning',
        description: 'Temperatures have exceeded 40°C.',
        severity: AlertSeverity.extreme,
        type: AlertType.heatwave,
        startTime: now,
        endTime: endTime,
        safetyGuidance: 'Stay hydrated and remain in cool, shaded, or air-conditioned areas.',
      ));
    }

    if (current.temperature < 0) {
      alerts.add(WeatherAlert(
        title: 'Cold Wave Warning',
        description: 'Temperatures have dropped below freezing.',
        severity: current.temperature < -10 ? AlertSeverity.extreme : AlertSeverity.high,
        type: AlertType.coldWave,
        startTime: now,
        endTime: endTime,
        safetyGuidance: 'Dress warmly in layers. Protect exposed skin from frostbite.',
      ));
    }

    if (airQuality != null) {
      final summary = airQuality.currentSummary;
      if (summary.aqi > 100) {
        alerts.add(WeatherAlert(
          title: 'Poor Air Quality',
          description: 'AQI is ${summary.aqi} (${summary.level}).',
          severity: summary.aqi > 150 ? AlertSeverity.extreme : AlertSeverity.high,
          type: AlertType.poorAqi,
          startTime: now,
          endTime: endTime,
          safetyGuidance: 'Sensitive groups should reduce outdoor exertion.',
        ));
      }
    }

    if (current.weatherCode >= 95 && current.weatherCode <= 99) {
      alerts.add(WeatherAlert(
        title: 'Storm Alert',
        description: 'Thunderstorms are currently active or imminent.',
        severity: AlertSeverity.extreme,
        type: AlertType.storm,
        startTime: now,
        endTime: endTime,
        safetyGuidance: 'Stay indoors away from windows. Disconnect sensitive electronics.',
      ));
    }

    return alerts;
  }
}
