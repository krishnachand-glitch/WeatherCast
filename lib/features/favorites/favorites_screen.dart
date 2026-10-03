import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/providers/favorites_provider.dart';
import 'package:weathercast_pro/providers/location_provider.dart';
import 'package:weathercast_pro/providers/weather_provider.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/gradient_scaffold.dart';
import 'package:weathercast_pro/features/search/search_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Favorite Locations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
            },
          ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 80, color: Colors.white.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite locations yet.\nSearch and save your places!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              onReorder: (oldIndex, newIndex) {
                ref.read(favoritesProvider.notifier).reorder(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return Dismissible(
                  key: ValueKey(favorite.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(favoritesProvider.notifier).removeFavorite(favorite.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      child: ListTile(
                        onTap: () {
                          ref.read(locationProvider.notifier).setLocation(favorite.location);
                          ref.read(weatherProvider.notifier).refresh();
                          Navigator.of(context).pop();
                        },
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          favorite.location.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              [favorite.location.admin1, favorite.location.country]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .join(', '),
                              style: TextStyle(color: Colors.white.withOpacity(0.7)),
                            ),
                            if (favorite.label != null && favorite.label!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    favorite.label!,
                                    style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.drag_handle, color: Colors.white54),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4FC3F7),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
