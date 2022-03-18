import 'dart:async';

import 'package:geolocator/geolocator.dart';
/* import 'package:get/get.dart'; */
import 'package:lamb_talent/core/user_preferences.dart';

class LocationUser {
  initLocationUser({verifyButton = false}) async {
/*     final opt =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

    final _geolocator = Geolocator();
    StreamSubscription _myubscription;
 */
    bool _serviceEnabled = false;
    LocationPermission _permission = LocationPermission.denied;
    final userPreferences = UserPreferences();
    userPreferences.optionLocation = '1';
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      print(
          'Ingresssssssssssssssssssssssssssssssssssssssssssssssssssssssssa aquí');
      userPreferences.latitude = '';
      userPreferences.longitude = '';
      userPreferences.optionLocation = '2';
      return;
    }
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      print(
          'Ingresssssssssssssssssssssssssssssssssssssssssssssssssssssssssa aquí2');
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
    final _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userPreferences.latitude = _position.latitude.toString();
    userPreferences.longitude = _position.longitude.toString();
    print('latitude:' + _position.latitude.toString());
    print('longitude:' + _position.longitude.toString());
    print(
        'Ingresssssssssssssssssssssssssssssssssssssssssssssssssssssssssa correctoooo');
    /*   final _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
 */
/*     Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                distanceFilter: 1, accuracy: LocationAccuracy.high))
        .listen((Position? _position) {
      userPreferences.latitude = _position!.latitude.toString();
      userPreferences.longitude = _position.longitude.toString();
      print('latitude:' + _position.latitude.toString());
      print('longitude:' + _position.longitude.toString());
    }); */
    userPreferences.optionLocation = '2';

    /*  _myubscription = Geolocator.getPositionStream(locationSettings: opt)
        .listen((Position _position) {
      userPreferences.latitude = _position.latitude.toString();
      userPreferences.longitude = _position.longitude.toString();
      print('latitude:' + _position.latitude.toString());
      print('longitude:' + _position.longitude.toString());
      Get.snackbar(
          'Ubicación',
          'latitude:' +
              _position.latitude.toString() +
              'longitude:' +
              _position.longitude.toString());
    }); */

    Timer? timePeriodic;
    timePeriodic = Timer.periodic(const Duration(minutes: 3), (timer) {
      userPreferences.optionLocation = '3';
      timePeriodic!.cancel();
    });
  }
}
