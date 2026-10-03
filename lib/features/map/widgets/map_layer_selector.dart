import 'package:flutter/material.dart';

class MapLayerSelector extends StatefulWidget {
  final String currentLayer;
  final ValueChanged<String> onLayerChanged;

  const MapLayerSelector({
    super.key,
    required this.currentLayer,
    required this.onLayerChanged,
  });

  @override
  State<MapLayerSelector> createState() => _MapLayerSelectorState();
}

class _MapLayerSelectorState extends State<MapLayerSelector> {
  bool _isExpanded = false;
  final List<String> _layers = ['Standard', 'Satellite', 'Terrain'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E).withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _layers.map((layer) {
                final isSelected = widget.currentLayer == layer;
                return InkWell(
                  onTap: () {
                    widget.onLayerChanged(layer);
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF4FC3F7).withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForLayer(layer),
                          color: isSelected ? const Color(0xFF4FC3F7) : Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          layer,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF4FC3F7) : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        FloatingActionButton(
          heroTag: 'btnLayers',
          backgroundColor: const Color(0xFF16213E),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Icon(_isExpanded ? Icons.close : Icons.layers, color: Colors.white),
        ),
      ],
    );
  }

  IconData _getIconForLayer(String layer) {
    switch (layer) {
      case 'Satellite':
        return Icons.satellite;
      case 'Terrain':
        return Icons.terrain;
      case 'Standard':
      default:
        return Icons.map;
    }
  }
}
