import 'package:flutter/material.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';

class WeatherIconWidget extends StatelessWidget {
  final int weatherCode;
  final bool isDay;
  final double size;

  const WeatherIconWidget({
    Key? key,
    required this.weatherCode,
    required this.isDay,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData = WeatherUtils.getWeatherIcon(weatherCode, isDay);
    List<Color> gradient = _getIconGradient(weatherCode, isDay);

    return Container(
      width: size * 1.5,
      height: size * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          size: size,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Color> _getIconGradient(int code, bool isDay) {
    if (code == 0) { 
      return isDay ? [Colors.orange[300]!, Colors.orange[600]!] : [Colors.blueGrey[700]!, Colors.blueGrey[900]!];
    } else if (code >= 1 && code <= 3 || code >= 45 && code <= 48) { 
      return isDay ? [Colors.grey[400]!, Colors.grey[600]!] : [Colors.blueGrey[600]!, Colors.blueGrey[800]!];
    } else if (code >= 51 && code <= 67 || code >= 80 && code <= 82) { 
      return [Colors.lightBlue[300]!, Colors.blue[600]!];
    } else if (code >= 71 && code <= 77 || code >= 85 && code <= 86) { 
      return [Colors.lightBlue[100]!, Colors.blue[200]!];
    } else if (code >= 95 && code <= 99) { 
      return [Colors.deepPurple[300]!, Colors.deepPurple[700]!];
    }
    return [Colors.grey[400]!, Colors.grey[600]!];
  }
}
