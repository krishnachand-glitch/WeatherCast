import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/core/services/location_service.dart';
import 'package:weathercast_pro/data/models/location_data.dart';
import 'package:weathercast_pro/providers/shared_providers.dart';

class LocationState {
  final LocationData? selectedLocation;
  final bool isLoading;
  final String? error;
  final bool permissionDenied;

  LocationState({
    this.selectedLocation,
    this.isLoading = false,
    this.error,
    this.permissionDenied = false,
  });

  LocationState copyWith({
    LocationData? selectedLocation,
    bool? isLoading,
    String? error,
    bool? permissionDenied,
  }) {
    return LocationState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      permissionDenied: permissionDenied ?? this.permissionDenied,
    );
  }

  String get cityName => selectedLocation?.name ?? 'Unknown';
  String? get country => selectedLocation?.country;
}

class LocationNotifier extends StateNotifier<LocationState> {
  final LocationService _locationService;
  final Ref _ref;
  
  LocationNotifier(this._locationService, this._ref) : super(LocationState(isLoading: true)) {
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final hasPermission = await _locationService.checkPermission();
      
      if (!hasPermission) {
        final granted = await _locationService.requestPermission();
        if (!granted) {
          // Default to New Delhi if permission denied
          state = state.copyWith(
            isLoading: false,
            permissionDenied: true,
            selectedLocation: LocationData(
              id: 0,
              name: 'New Delhi',
              latitude: 28.6139,
              longitude: 77.2090,
              country: 'India',
              admin1: 'Delhi',
            ),
          );
          return;
        }
      }
      
      final position = await _locationService.getCurrentPosition();
      state = state.copyWith(
        isLoading: false,
        permissionDenied: false,
        selectedLocation: LocationData(
          id: 0,
          name: 'Current Location',
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        selectedLocation: LocationData(
          id: 0,
          name: 'New Delhi',
          latitude: 28.6139,
          longitude: 77.2090,
          country: 'India',
          admin1: 'Delhi',
        ),
      );
    }
  }

  void setLocation(LocationData location) {
    state = state.copyWith(
      selectedLocation: location,
      isLoading: false,
      error: null,
    );
  }

  Future<void> detectCurrentLocation() async {
    await _initLocation();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(ref.read(locationServiceProvider), ref);
});
