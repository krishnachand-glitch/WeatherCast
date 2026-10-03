import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/providers/shared_providers.dart';

class WeatherNotifier extends AsyncNotifier<WeatherData> {
  @override
  Future<WeatherData> build() async {
    final location = ref.watch(currentLocationProvider);
    if (location == null) {
      throw Exception('No location available');
    }
    
    final repo = ref.read(weatherRepositoryProvider);
    return repo.getWeather(location.latitude, location.longitude);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherData>(() {
  return WeatherNotifier();
});
