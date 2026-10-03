import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/data/models/air_quality_data.dart';
import 'package:weathercast_pro/providers/shared_providers.dart';

class AirQualityNotifier extends AsyncNotifier<AirQualityData> {
  @override
  Future<AirQualityData> build() async {
    final location = ref.watch(currentLocationProvider);
    if (location == null) {
      throw Exception('No location available');
    }
    
    final repo = ref.read(airQualityRepositoryProvider);
    return repo.getAirQuality(location.latitude, location.longitude);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final airQualityProvider = AsyncNotifierProvider<AirQualityNotifier, AirQualityData>(() {
  return AirQualityNotifier();
});
