class WeatherData {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;
  final double latitude;
  final double longitude;
  final String timezone;

  WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(json['current']);
    
    final hourlyJson = json['hourly'];
    final List<HourlyWeather> hourlyList = [];
    if (hourlyJson != null) {
      final List times = hourlyJson['time'];
      for (int i = 0; i < times.length; i++) {
        hourlyList.add(HourlyWeather.fromJson(hourlyJson, i));
      }
    }

    final dailyJson = json['daily'];
    final List<DailyWeather> dailyList = [];
    if (dailyJson != null) {
      final List times = dailyJson['time'];
      for (int i = 0; i < times.length; i++) {
        dailyList.add(DailyWeather.fromJson(dailyJson, i));
      }
    }

    return WeatherData(
      current: current,
      hourly: hourlyList,
      daily: dailyList,
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezone: json['timezone'],
    );
  }
}

class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final int weatherCode;
  final double windSpeed;
  final double windDirection;
  final double pressure;
  final double uvIndex;
  final double visibility;
  final DateTime time;

  CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.uvIndex,
    required this.visibility,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] ?? 0).toDouble(),
      apparentTemperature: (json['apparent_temperature'] ?? 0).toDouble(),
      relativeHumidity: json['relative_humidity_2m'] ?? 0,
      weatherCode: json['weather_code'] ?? 0,
      windSpeed: (json['wind_speed_10m'] ?? 0).toDouble(),
      windDirection: (json['wind_direction_10m'] ?? 0).toDouble(),
      pressure: (json['pressure_msl'] ?? 0).toDouble(),
      uvIndex: (json['uv_index'] ?? 0).toDouble(),
      visibility: (json['visibility'] ?? 0).toDouble(),
      time: DateTime.parse(json['time']),
    );
  }
}

class HourlyWeather {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final int weatherCode;
  final int precipitationProbability;
  final double precipitation;
  final double windSpeed;
  final double windDirection;
  final double uvIndex;
  final double visibility;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.weatherCode,
    required this.precipitationProbability,
    required this.precipitation,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.visibility,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json, int index) {
    return HourlyWeather(
      time: DateTime.parse(json['time'][index]),
      temperature: (json['temperature_2m'][index] ?? 0).toDouble(),
      apparentTemperature: (json['apparent_temperature'][index] ?? 0).toDouble(),
      relativeHumidity: json['relative_humidity_2m'][index] ?? 0,
      weatherCode: json['weather_code'][index] ?? 0,
      precipitationProbability: json['precipitation_probability'][index] ?? 0,
      precipitation: (json['precipitation'][index] ?? 0).toDouble(),
      windSpeed: (json['wind_speed_10m'][index] ?? 0).toDouble(),
      windDirection: (json['wind_direction_10m'][index] ?? 0).toDouble(),
      uvIndex: (json['uv_index'][index] ?? 0).toDouble(),
      visibility: (json['visibility'][index] ?? 0).toDouble(),
    );
  }
}

class DailyWeather {
  final DateTime date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final double apparentTemperatureMax;
  final double apparentTemperatureMin;
  final DateTime sunrise;
  final DateTime sunset;
  final double uvIndexMax;
  final double precipitationSum;
  final double rainSum;
  final int precipitationProbabilityMax;
  final double windSpeedMax;

  DailyWeather({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.sunrise,
    required this.sunset,
    required this.uvIndexMax,
    required this.precipitationSum,
    required this.rainSum,
    required this.precipitationProbabilityMax,
    required this.windSpeedMax,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json, int index) {
    return DailyWeather(
      date: DateTime.parse(json['time'][index]),
      weatherCode: json['weather_code'][index] ?? 0,
      temperatureMax: (json['temperature_2m_max'][index] ?? 0).toDouble(),
      temperatureMin: (json['temperature_2m_min'][index] ?? 0).toDouble(),
      apparentTemperatureMax: (json['apparent_temperature_max'][index] ?? 0).toDouble(),
      apparentTemperatureMin: (json['apparent_temperature_min'][index] ?? 0).toDouble(),
      sunrise: DateTime.parse(json['sunrise'][index]),
      sunset: DateTime.parse(json['sunset'][index]),
      uvIndexMax: (json['uv_index_max'][index] ?? 0).toDouble(),
      precipitationSum: (json['precipitation_sum'][index] ?? 0).toDouble(),
      rainSum: (json['rain_sum'][index] ?? 0).toDouble(),
      precipitationProbabilityMax: json['precipitation_probability_max'][index] ?? 0,
      windSpeedMax: (json['wind_speed_10m_max'][index] ?? 0).toDouble(),
    );
  }
}
