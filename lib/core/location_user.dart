import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:lamb_talent/core/user_preferences.dart';

class LocationUser {
  initLocationUser({verifyButton = false}) async {
    bool _serviceEnabled = false;
    LocationPermission _permission = LocationPermission.denied;
    final userPreferences = UserPreferences();
    userPreferences.optionLocation = '1';
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      userPreferences.latitude = '';
      userPreferences.longitude = '';
      userPreferences.optionLocation = '2';
      return;
    }
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        userPreferences.latitude = '';
        userPreferences.longitude = '';
        userPreferences.optionLocation = '2';
        return;
      }
    }
    if (_permission != LocationPermission.always &&
        _permission != LocationPermission.whileInUse) {
      userPreferences.latitude = '';
      userPreferences.longitude = '';
      userPreferences.optionLocation = '2';
      return;
    }
    final _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userPreferences.latitude = _position.latitude.toString();
    userPreferences.longitude = _position.longitude.toString();
    userPreferences.optionLocation = '2';
    Timer? timePeriodic;
    timePeriodic = Timer.periodic(const Duration(minutes: 3), (timer) {
      userPreferences.optionLocation = '3';
      timePeriodic!.cancel();
    });
  }
}
