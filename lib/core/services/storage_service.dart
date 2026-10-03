import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

enum TemperatureUnit { celsius, fahrenheit, kelvin }
enum WindUnit { kmh, mph, ms, knots }

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Box _settingsBox;
  late Box _weatherCacheBox;
  
  Future<void> init() async {
    _settingsBox = Hive.box('settings');
    _weatherCacheBox = Hive.box('weather_cache');
  }

  TemperatureUnit getTemperatureUnit() {
    final index = _settingsBox.get('temp_unit', defaultValue: 0);
    return TemperatureUnit.values[index];
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    await _settingsBox.put('temp_unit', unit.index);
  }

  WindUnit getWindUnit() {
    final index = _settingsBox.get('wind_unit', defaultValue: 0);
    return WindUnit.values[index];
  }

  Future<void> setWindUnit(WindUnit unit) async {
    await _settingsBox.put('wind_unit', unit.index);
  }

  ThemeMode getThemeMode() {
    final index = _settingsBox.get('theme_mode', defaultValue: 0);
    return ThemeMode.values[index];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _settingsBox.put('theme_mode', mode.index);
  }

  String _getCacheKey(double lat, double lng) => '${lat.toStringAsFixed(4)}_${lng.toStringAsFixed(4)}';

  Future<void> saveWeatherCache(double lat, double lng, Map<String, dynamic> json) async {
    final key = _getCacheKey(lat, lng);
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'data': jsonEncode(json),
    };
    await _weatherCacheBox.put(key, data);
  }

  Map<String, dynamic>? getWeatherCache(double lat, double lng) {
    final key = _getCacheKey(lat, lng);
    final data = _weatherCacheBox.get(key);
    if (data != null) {
      return jsonDecode(data['data']);
    }
    return null;
  }

  bool isCacheValid(double lat, double lng) {
    final key = _getCacheKey(lat, lng);
    final data = _weatherCacheBox.get(key);
    if (data != null) {
      final timestamp = DateTime.parse(data['timestamp']);
      return DateTime.now().difference(timestamp).inMinutes < 10;
    }
    return false;
  }
}
