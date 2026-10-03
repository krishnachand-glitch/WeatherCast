import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class UvUtils {
  static String getUvLevel(double uv) {
    if (uv < 3) return 'Low';
    if (uv < 6) return 'Moderate';
    if (uv < 8) return 'High';
    if (uv < 11) return 'Very High';
    return 'Extreme';
  }

  static Color getUvColor(double uv) {
    if (uv < 3) return AppColors.uvLow;
    if (uv < 6) return AppColors.uvModerate;
    if (uv < 8) return AppColors.uvHigh;
    if (uv < 11) return AppColors.uvVeryHigh;
    return AppColors.uvExtreme;
  }

  static String getUvRecommendation(double uv) {
    if (uv < 3) return 'Safe to be outside. No special protection is required.';
    if (uv < 6) return 'Protection required. Seek shade during midday hours, wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses.';
    if (uv < 8) return 'Protection essential. Reduce time in the sun between 10 a.m. and 4 p.m.';
    if (uv < 11) return 'Extra protection needed. Avoid sun exposure between 10 a.m. and 4 p.m.';
    return 'Extreme danger. Take all precautions, avoid the sun entirely if possible.';
  }
}
