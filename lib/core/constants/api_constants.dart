class ApiConstants {
  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String airQualityBaseUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';
  static const String geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  
  static const String hourlyParams = 'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,precipitation,weather_code,wind_speed_10m,wind_direction_10m,uv_index,visibility';
  static const String dailyParams = 'weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,uv_index_max,precipitation_sum,rain_sum,precipitation_probability_max,wind_speed_10m_max';
  static const String currentParams = 'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,wind_direction_10m,pressure_msl,uv_index,visibility';
  static const String airQualityParams = 'pm10,pm2_5,nitrogen_dioxide,ozone,european_aqi';
  
  static String buildWeatherUrl(double lat, double lng) {
    return '$weatherBaseUrl?latitude=$lat&longitude=$lng&current=$currentParams&hourly=$hourlyParams&daily=$dailyParams&timezone=auto';
  }
  
  static String buildAqiUrl(double lat, double lng) {
    return '$airQualityBaseUrl?latitude=$lat&longitude=$lng&hourly=$airQualityParams&timezone=auto';
  }
  
  static String buildGeocodingUrl(String query) {
    return '$geocodingBaseUrl?name=$query&count=10&language=en&format=json';
  }
}
