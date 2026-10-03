import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) {
      final granted = await requestPermission();
      if (!granted) {
        throw Exception('Location permission denied');
      }
    }
    
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<bool> checkPermission() async {
    var permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<bool> requestPermission() async {
    var box = Hive.box('settings');
    bool hasRequested = box.get('has_requested_location', defaultValue: false);
    
    if (hasRequested) {
      var status = await Permission.location.request();
      return status.isGranted;
    } else {
      await box.put('has_requested_location', true);
      var permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    }
  }

  Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
  }
}
