import 'package:weathercast_pro/core/constants/api_constants.dart';
import 'package:weathercast_pro/core/services/api_client.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';

class WeatherRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  WeatherRepository(this._apiClient, this._storageService);

  Future<WeatherData> getWeather(double lat, double lng) async {
    final url =
        '${ApiConstants.weatherBaseUrl}?latitude=$lat&longitude=$lng'
        '&hourly=${ApiConstants.hourlyParams}'
        '&daily=${ApiConstants.dailyParams}'
        '&current=${ApiConstants.currentParams}'
        '&timezone=auto&forecast_days=7&forecast_hours=48';

    try {
      final response = await _apiClient.get(url);
      final weatherData = WeatherData.fromJson(response);

      // Cache the raw response for offline fallback
      await _storageService.saveWeatherCache(lat, lng, response);
      return weatherData;
    } catch (e) {
      // Try offline cache fallback
      if (_storageService.isCacheValid(lat, lng)) {
        final cachedData = _storageService.getWeatherCache(lat, lng);
        if (cachedData != null) {
          return WeatherData.fromJson(cachedData);
        }
      }
      rethrow;
    }
  }

  Future<WeatherData?> getWeatherCached(double lat, double lng) async {
    final cachedData = _storageService.getWeatherCache(lat, lng);
    if (cachedData != null) {
      return WeatherData.fromJson(cachedData);
    }
    return null;
  }
}
