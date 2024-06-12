//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars

// import 'package:connectivity_plus_web/connectivity_plus_web.dart';
// import 'package:device_info_plus_web/device_info_plus_web.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core_web/firebase_core_web.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_messaging_web/firebase_messaging_web.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator_web/geolocator_web.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker_for_web/image_picker_for_web.dart';
// import 'package:share_plus_web/share_plus_web.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences_web/shared_preferences_web.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_web/url_launcher_web.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player_web/video_player_web.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  // ConnectivityPlusPlugin.registerWith(registrar);
  // DeviceInfoPlusPlugin.registerWith(registrar);
  FilePickerWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseMessagingWeb.registerWith(registrar);
  GeolocatorPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  // SharePlusPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  VideoPlayerPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
