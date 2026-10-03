import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AqiUtils {
  static String getAqiLevel(int aqi) {
    if (aqi <= 25) return 'Good';
    if (aqi <= 50) return 'Fair';
    if (aqi <= 75) return 'Moderate';
    if (aqi <= 100) return 'Poor';
    return 'Very Poor';
  }

  static Color getAqiColor(int aqi) {
    if (aqi <= 25) return AppColors.aqiGood;
    if (aqi <= 50) return AppColors.aqiModerate;
    if (aqi <= 75) return AppColors.aqiPoor;
    if (aqi <= 100) return AppColors.aqiUnhealthy;
    return AppColors.aqiHazardous;
  }

  static String getAqiDescription(int aqi) {
    if (aqi <= 25) return 'Air quality is satisfactory, and air pollution poses little or no risk.';
    if (aqi <= 50) return 'Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.';
    if (aqi <= 75) return 'Members of sensitive groups may experience health effects. The general public is less likely to be affected.';
    if (aqi <= 100) return 'Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.';
    return 'Health alert: The risk of health effects is increased for everyone.';
  }

  static IconData getAqiIcon(int aqi) {
    if (aqi <= 25) return Icons.sentiment_very_satisfied;
    if (aqi <= 50) return Icons.sentiment_satisfied;
    if (aqi <= 75) return Icons.sentiment_neutral;
    if (aqi <= 100) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  static double getAqiPercentage(int aqi) {
    return (aqi.clamp(0, 150) / 150.0);
  }
}
