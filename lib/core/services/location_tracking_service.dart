import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTrackingService {
  static final LocationTrackingService _instance = LocationTrackingService._internal();
  factory LocationTrackingService() => _instance;
  LocationTrackingService._internal();

  StreamSubscription<Position>? _positionStream;
  final _userLocationController = StreamController<LatLng>.broadcast();
  
  Stream<LatLng> get userLocationStream => _userLocationController.stream;

  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      return result == LocationPermission.whileInUse || result == LocationPermission.always;
    }
    return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      if (kDebugMode) print('Erro ao obter localização: $e');
      return null;
    }
  }

  Future<void> startLocationTracking() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        if (kDebugMode) print('Permissão de localização negada');
        return;
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen(
        (Position position) {
          _userLocationController.add(LatLng(position.latitude, position.longitude));
        },
        onError: (error) {
          if (kDebugMode) print('Erro ao obter localização: $error');
        },
      );
    } catch (e) {
      if (kDebugMode) print('Erro ao iniciar rastreamento: $e');
    }
  }

  void stopLocationTracking() {
    _positionStream?.cancel();
  }

  void dispose() {
    _positionStream?.cancel();
    _userLocationController.close();
  }

  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }
}
