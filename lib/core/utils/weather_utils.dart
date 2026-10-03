import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class WeatherUtils {
  static String getConditionText(int wmoCode) {
    switch (wmoCode) {
      case 0: return 'Clear sky';
      case 1:
      case 2:
      case 3: return 'Partly cloudy';
      case 45:
      case 48: return 'Fog';
      case 51:
      case 53:
      case 55: return 'Drizzle';
      case 56:
      case 57: return 'Freezing drizzle';
      case 61:
      case 63:
      case 65: return 'Rain';
      case 66:
      case 67: return 'Freezing rain';
      case 71:
      case 73:
      case 75: return 'Snow';
      case 77: return 'Snow grains';
      case 80:
      case 81:
      case 82: return 'Rain showers';
      case 85:
      case 86: return 'Snow showers';
      case 95: return 'Thunderstorm';
      case 96:
      case 99: return 'Thunderstorm with hail';
      default: return 'Unknown';
    }
  }

  static IconData getWeatherIcon(int wmoCode, bool isDay) {
    if (wmoCode == 0) return isDay ? Icons.wb_sunny : Icons.nightlight_round;
    if (wmoCode >= 1 && wmoCode <= 3) return isDay ? Icons.wb_cloudy : Icons.cloud;
    if (wmoCode == 45 || wmoCode == 48) return Icons.cloud_queue;
    if (wmoCode >= 51 && wmoCode <= 67) return Icons.water_drop;
    if (wmoCode >= 71 && wmoCode <= 77) return Icons.ac_unit;
    if (wmoCode >= 80 && wmoCode <= 82) return Icons.grain;
    if (wmoCode >= 85 && wmoCode <= 86) return Icons.ac_unit;
    if (wmoCode >= 95 && wmoCode <= 99) return Icons.flash_on;
    return Icons.wb_sunny;
  }

  static String getWeatherEmoji(int wmoCode) {
    if (wmoCode == 0) return '☀️';
    if (wmoCode >= 1 && wmoCode <= 3) return '⛅';
    if (wmoCode == 45 || wmoCode == 48) return '🌫️';
    if (wmoCode >= 51 && wmoCode <= 67) return '🌧️';
    if (wmoCode >= 71 && wmoCode <= 77) return '❄️';
    if (wmoCode >= 80 && wmoCode <= 82) return '🌦️';
    if (wmoCode >= 85 && wmoCode <= 86) return '🌨️';
    if (wmoCode >= 95 && wmoCode <= 99) return '⛈️';
    return '❓';
  }

  static List<Color> getBackgroundGradient(int wmoCode, bool isDay) {
    if (!isDay) return [AppColors.nightGradientStart, AppColors.nightGradientEnd];
    if (wmoCode == 0) return [AppColors.sunnyGradientStart, AppColors.sunnyGradientEnd];
    if (wmoCode >= 1 && wmoCode <= 3) return [AppColors.cloudyGradientStart, AppColors.cloudyGradientEnd];
    if (wmoCode >= 51 && wmoCode <= 67) return [AppColors.rainyGradientStart, AppColors.rainyGradientEnd];
    if (wmoCode >= 71 && wmoCode <= 77) return [AppColors.snowGradientStart, AppColors.snowGradientEnd];
    if (wmoCode >= 95 && wmoCode <= 99) return [AppColors.stormGradientStart, AppColors.stormGradientEnd];
    return [AppColors.cloudyGradientStart, AppColors.cloudyGradientEnd];
  }

  static bool isDay(DateTime sunrise, DateTime sunset, DateTime now) {
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }

  static String getWindDirection(double degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N'];
    return directions[((degrees % 360) / 45).round()];
  }

  static double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;
  static double celsiusToKelvin(double celsius) => celsius + 273.15;
  static double kmhToMph(double kmh) => kmh * 0.621371;
  static double kmhToMs(double kmh) => kmh / 3.6;
  static double kmhToKnots(double kmh) => kmh * 0.539957;
}
