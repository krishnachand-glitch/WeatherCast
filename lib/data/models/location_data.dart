class LocationData {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? countryCode;
  final String? admin1;
  final String? admin2;
  final String? admin3;
  final String? timezone;
  final int? population;
  final double? elevation;

  LocationData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.countryCode,
    this.admin1,
    this.admin2,
    this.admin3,
    this.timezone,
    this.population,
    this.elevation,
  });

  String get displayName => admin1 != null ? '$name, $admin1' : name;
  String get fullDisplayName => country != null ? '$displayName, $country' : displayName;

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      country: json['country'],
      countryCode: json['country_code'],
      admin1: json['admin1'],
      admin2: json['admin2'],
      admin3: json['admin3'],
      timezone: json['timezone'],
      population: json['population'],
      elevation: json['elevation'] != null ? (json['elevation']).toDouble() : null,
    );
  }
}
