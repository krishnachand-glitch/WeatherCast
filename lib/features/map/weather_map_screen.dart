import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weathercast_pro/providers/location_provider.dart';
import 'package:weathercast_pro/providers/weather_provider.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/features/map/widgets/map_layer_selector.dart';

class WeatherMapScreen extends ConsumerStatefulWidget {
  const WeatherMapScreen({super.key});

  @override
  ConsumerState<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends ConsumerState<WeatherMapScreen> {
  final MapController _mapController = MapController();
  double _zoom = 8.0;
  String _currentLayer = 'Standard';

  void _onLayerChanged(String layer) {
    setState(() {
      _currentLayer = layer;
    });
  }

  String getTileUrl() {
    switch (_currentLayer) {
      case 'Satellite':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'Terrain':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}';
      case 'Standard':
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final weatherState = ref.watch(weatherProvider);
    
    final LatLng center = locationState.selectedLocation != null 
        ? LatLng(locationState.selectedLocation!.latitude, locationState.selectedLocation!.longitude)
        : const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Map'),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: _zoom,
            ),
            children: [
              TileLayer(
                urlTemplate: getTileUrl(),
                userAgentPackageName: 'com.example.weathercast_pro',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: 80,
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                        if (weatherState.value != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${weatherState.value!.current.temperature.round()}°',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'btnZoomIn',
                  backgroundColor: const Color(0xFF16213E),
                  onPressed: () {
                    setState(() {
                      _zoom++;
                      _mapController.move(_mapController.camera.center, _zoom);
                    });
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'btnZoomOut',
                  backgroundColor: const Color(0xFF16213E),
                  onPressed: () {
                    setState(() {
                      _zoom--;
                      _mapController.move(_mapController.camera.center, _zoom);
                    });
                  },
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 120,
            child: MapLayerSelector(
              currentLayer: _currentLayer,
              onLayerChanged: _onLayerChanged,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white, size: 30),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            locationState.cityName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            weatherState.value != null 
                                ? 'Currently ${weatherState.value!.current.temperature.round()}°' 
                                : 'Loading...',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
