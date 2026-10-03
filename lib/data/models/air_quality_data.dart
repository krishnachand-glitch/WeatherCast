import 'package:flutter/material.dart';
import '../../core/utils/aqi_utils.dart';

class AirQualityData {
  final List<HourlyAirQuality> hourly;

  AirQualityData({required this.hourly});

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    final hourlyJson = json['hourly'];
    final List<HourlyAirQuality> list = [];
    if (hourlyJson != null) {
      final List times = hourlyJson['time'];
      for (int i = 0; i < times.length; i++) {
        list.add(HourlyAirQuality.fromJson(hourlyJson, i));
      }
    }
    return AirQualityData(hourly: list);
  }

  AirQualitySummary get currentSummary {
    if (hourly.isEmpty) {
      return AirQualitySummary(
        aqi: 0,
        pm25: 0,
        pm10: 0,
        no2: 0,
        o3: 0,
        level: 'Unknown',
        description: 'No data',
        color: Colors.grey,
      );
    }
    
    final now = DateTime.now();
    HourlyAirQuality current = hourly.first;
    for (var h in hourly) {
      if (h.time.difference(now).abs() < current.time.difference(now).abs()) {
        current = h;
      }
    }

    return AirQualitySummary(
      aqi: current.europeanAqi,
      pm25: current.pm25,
      pm10: current.pm10,
      no2: current.nitrogenDioxide,
      o3: current.ozone,
      level: AqiUtils.getAqiLevel(current.europeanAqi),
      description: AqiUtils.getAqiDescription(current.europeanAqi),
      color: AqiUtils.getAqiColor(current.europeanAqi),
    );
  }
}

class HourlyAirQuality {
  final DateTime time;
  final double pm10;
  final double pm25;
  final double nitrogenDioxide;
  final double ozone;
  final int europeanAqi;

  HourlyAirQuality({
    required this.time,
    required this.pm10,
    required this.pm25,
    required this.nitrogenDioxide,
    required this.ozone,
    required this.europeanAqi,
  });

  factory HourlyAirQuality.fromJson(Map<String, dynamic> json, int index) {
    return HourlyAirQuality(
      time: DateTime.parse(json['time'][index]),
      pm10: (json['pm10'][index] ?? 0).toDouble(),
      pm25: (json['pm2_5'][index] ?? 0).toDouble(),
      nitrogenDioxide: (json['nitrogen_dioxide'][index] ?? 0).toDouble(),
      ozone: (json['ozone'][index] ?? 0).toDouble(),
      europeanAqi: json['european_aqi'][index] ?? 0,
    );
  }
}

class AirQualitySummary {
  final int aqi;
  final double pm25;
  final double pm10;
  final double no2;
  final double o3;
  final String level;
  final String description;
  final Color color;

  AirQualitySummary({
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.o3,
    required this.level,
    required this.description,
    required this.color,
  });
}
