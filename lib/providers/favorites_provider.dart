import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/data/models/favorite_location.dart';
import 'package:weathercast_pro/data/repositories/favorites_repository.dart';
import 'package:weathercast_pro/providers/shared_providers.dart';

class FavoritesNotifier extends StateNotifier<List<FavoriteLocation>> {
  final FavoritesRepository _repository;
  
  FavoritesNotifier(this._repository) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    state = _repository.getAll();
  }

  Future<void> addFavorite(FavoriteLocation fav) async {
    await _repository.add(fav);
    _loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await _repository.remove(id);
    _loadFavorites();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final items = List<FavoriteLocation>.from(state);
    final item = items.removeAt(oldIndex);
    
    final adjustedIndex = newIndex < oldIndex ? newIndex : newIndex - 1;
    items.insert(adjustedIndex, item);
    
    state = items;
    await _repository.saveAll(items);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteLocation>>((ref) {
  return FavoritesNotifier(ref.read(favoritesRepositoryProvider));
});
