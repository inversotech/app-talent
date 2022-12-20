import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
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
    final _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userPreferences.latitude = _position.latitude.toString();
    userPreferences.longitude = _position.longitude.toString();
    userPreferences.optionLocation = '2';
    /* Timer? timePeriodic;
    timePeriodic = Timer.periodic(const Duration(minutes: 3), (timer) {
      userPreferences.optionLocation = '3';
      timePeriodic!.cancel();
    }); */
    this.changeLocationUser();
  }

  changeLocationUser() {
    final userPreferences = UserPreferences();
   late LocationSettings locationSettings;

if (Platform.isAndroid) {
  locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
    forceLocationManager: true,
    intervalDuration: const Duration(seconds: 10),
    //(Optional) Set foreground notification config to keep the app alive 
    //when going to the background
    foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
        "Example app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
    )
  );
} else if (Platform.isIOS || Platform.isMacOS) {
  locationSettings = AppleSettings(
    accuracy: LocationAccuracy.high,
    activityType: ActivityType.fitness,
    distanceFilter: 5,
    pauseLocationUpdatesAutomatically: true,
    // Only set to true if our app will be started up in the background.
    showBackgroundLocationIndicator: false,
  );
} else {
    locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );
}
    Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        print(position.latitude);
        print(position.longitude);
        userPreferences.latitude = position.latitude.toString();
        userPreferences.longitude = position.longitude.toString();
      }
    });
  }
}
