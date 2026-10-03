import 'dart:convert';
import 'location_data.dart';

class FavoriteLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String label;
  final DateTime addedAt;

  FavoriteLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    required this.label,
    required this.addedAt,
  });

  factory FavoriteLocation.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return FavoriteLocation(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
      admin1: json['admin1'],
      label: json['label'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'label': label,
      'addedAt': addedAt.toIso8601String(),
    });
  }

  factory FavoriteLocation.fromLocationData(LocationData loc, String label) {
    return FavoriteLocation(
      id: loc.id.toString(),
      name: loc.name,
      latitude: loc.latitude,
      longitude: loc.longitude,
      country: loc.country,
      admin1: loc.admin1,
      label: label,
      addedAt: DateTime.now(),
    );
  }
}
