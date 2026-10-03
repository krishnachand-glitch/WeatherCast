import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/data/models/location_data.dart';
import 'package:weathercast_pro/core/services/api_client.dart';
import 'package:weathercast_pro/data/repositories/geocoding_repository.dart';
import 'package:weathercast_pro/providers/location_provider.dart';
import 'package:weathercast_pro/providers/weather_provider.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/gradient_scaffold.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<LocationData> _results = [];
  bool _isLoading = false;
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.length < 2) {
      setState(() {
        _results = [];
        _isLoading = false;
        _lastQuery = query;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _lastQuery = query;
    });

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final repo = GeocodingRepository(ApiClient());
        final results = await repo.search(query);
        if (mounted && _lastQuery == query) {
          setState(() {
            _results = results;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted && _lastQuery == query) {
          setState(() {
            _results = [];
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search for a city...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.search, color: Colors.white70),
                          border: InputBorder.none,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.white70),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_searchController.text.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.white.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text(
                        'Search for a city, town, or place',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            else if (_results.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No locations found for "${_searchController.text}"',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final location = _results[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        child: ListTile(
                          leading: const Icon(Icons.location_on, color: Color(0xFF4FC3F7)),
                          title: Text(
                            location.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            [location.admin1, location.country].where((e) => e != null && e.isNotEmpty).join(', '),
                            style: TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          onTap: () {
                            ref.read(locationProvider.notifier).setLocation(location);
                            ref.read(weatherProvider.notifier).refresh();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
