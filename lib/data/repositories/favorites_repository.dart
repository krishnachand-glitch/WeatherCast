import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weathercast_pro/data/models/favorite_location.dart';

class FavoritesRepository {
  static const String _boxName = 'favorites';

  List<FavoriteLocation> getAll() {
    final box = Hive.box<String>(_boxName);
    final List<FavoriteLocation> favorites = [];
    
    for (final value in box.values) {
      try {
        final decoded = jsonDecode(value) as Map<String, dynamic>;
        favorites.add(FavoriteLocation.fromJson(decoded));
      } catch (_) {
        // Skip invalid entries
      }
    }
    return favorites;
  }

  Future<void> add(FavoriteLocation fav) async {
    final box = Hive.box<String>(_boxName);
    final jsonStr = jsonEncode(fav.toJson());
    await box.put(fav.id, jsonStr);
  }

  Future<void> remove(String id) async {
    final box = Hive.box<String>(_boxName);
    await box.delete(id);
  }

  Future<void> saveAll(List<FavoriteLocation> favorites) async {
    final box = Hive.box<String>(_boxName);
    await box.clear();
    
    final Map<String, String> entries = {};
    for (final fav in favorites) {
      entries[fav.id] = jsonEncode(fav.toJson());
    }
    
    await box.putAll(entries);
  }
}
