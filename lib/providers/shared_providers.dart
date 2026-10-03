import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/core/services/api_client.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/core/services/location_service.dart';
import 'package:weathercast_pro/data/repositories/weather_repository.dart';
import 'package:weathercast_pro/data/repositories/air_quality_repository.dart';
import 'package:weathercast_pro/data/repositories/favorites_repository.dart';
import 'package:weathercast_pro/data/models/location_data.dart';
import 'package:weathercast_pro/providers/location_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(
    ref.read(apiClientProvider),
    ref.read(storageServiceProvider),
  );
});

final airQualityRepositoryProvider = Provider<AirQualityRepository>((ref) {
  return AirQualityRepository(ref.read(apiClientProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

final currentLocationProvider = Provider<LocationData?>((ref) {
  return ref.watch(locationProvider).selectedLocation;
});
