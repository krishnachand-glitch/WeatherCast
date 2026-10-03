import 'package:weathercast_pro/core/constants/api_constants.dart';
import 'package:weathercast_pro/core/services/api_client.dart';
import 'package:weathercast_pro/data/models/location_data.dart';

class GeocodingRepository {
  final ApiClient _apiClient;

  GeocodingRepository(this._apiClient);

  Future<List<LocationData>> search(String query) async {
    if (query.trim().length < 2) {
      return [];
    }

    final url = '${ApiConstants.geocodingBaseUrl}?name=$query&count=10&language=en&format=json';

    try {
      final response = await _apiClient.get(url);
      
      if (response.containsKey('results') && response['results'] != null) {
        final results = response['results'] as List<dynamic>;
        return results
            .map((item) => LocationData.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      // Don't crash for search errors, just return empty list
      return [];
    }
  }
}
