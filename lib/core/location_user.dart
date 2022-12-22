import 'package:geolocator/geolocator.dart';
import 'package:lamb_talent/core/user_preferences.dart';

class LocationUser {
  initLocationUser({verifyButton = false}) async {
    bool serviceEnabled = false;
    LocationPermission permission = LocationPermission.denied;
    final userPreferences = UserPreferences();
    userPreferences.optionLocation = '1';
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      userPreferences.latitude = '';
      userPreferences.longitude = '';
      userPreferences.optionLocation = '2';
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        userPreferences.latitude = '';
        userPreferences.longitude = '';
        userPreferences.optionLocation = '2';
        return;
      }
    }
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      userPreferences.latitude = '';
      userPreferences.longitude = '';
      userPreferences.optionLocation = '2';
      return;
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userPreferences.latitude = position.latitude.toString();
    userPreferences.longitude = position.longitude.toString();
    userPreferences.optionLocation = '2';
    /* Timer? timePeriodic;
    timePeriodic = Timer.periodic(const Duration(minutes: 3), (timer) {
      userPreferences.optionLocation = '3';
      timePeriodic!.cancel();
    }); */
  }
}
