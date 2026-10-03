import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/providers/shared_providers.dart';

class SettingsState {
  final TemperatureUnit temperatureUnit;
  final WindUnit windUnit;

  SettingsState({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windUnit = WindUnit.kmh,
  });

  SettingsState copyWith({
    TemperatureUnit? temperatureUnit,
    WindUnit? windUnit,
  }) {
    return SettingsState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windUnit: windUnit ?? this.windUnit,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storageService;
  
  SettingsNotifier(this._storageService) : super(SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final tempUnit = _storageService.getTemperatureUnit();
    final windUnit = _storageService.getWindUnit();
    state = SettingsState(temperatureUnit: tempUnit, windUnit: windUnit);
  }

  void setTemperatureUnit(TemperatureUnit unit) {
    _storageService.setTemperatureUnit(unit);
    state = state.copyWith(temperatureUnit: unit);
  }

  void setWindUnit(WindUnit unit) {
    _storageService.setWindUnit(unit);
    state = state.copyWith(windUnit: unit);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref.read(storageServiceProvider));
});
