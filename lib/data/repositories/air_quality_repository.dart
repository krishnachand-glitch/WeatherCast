import 'package:weathercast_pro/core/constants/api_constants.dart';
import 'package:weathercast_pro/core/services/api_client.dart';
import 'package:weathercast_pro/data/models/air_quality_data.dart';

class AirQualityRepository {
  final ApiClient _apiClient;

  AirQualityRepository(this._apiClient);

  Future<AirQualityData> getAirQuality(double lat, double lng) async {
    final url = '${ApiConstants.airQualityBaseUrl}?latitude=$lat&longitude=$lng&hourly=${ApiConstants.airQualityParams}&timezone=auto';
    
    try {
      final response = await _apiClient.get(url);
      return AirQualityData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
