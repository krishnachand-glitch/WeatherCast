import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';
import 'package:weathercast_pro/providers/shared_providers.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final StorageService _storageService;
  
  ThemeNotifier(this._storageService) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final mode = _storageService.getThemeMode();
    state = mode;
  }

  void setThemeMode(ThemeMode mode) {
    _storageService.setThemeMode(mode);
    state = mode;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.read(storageServiceProvider));
});
