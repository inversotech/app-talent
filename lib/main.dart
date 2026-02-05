import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/resources/services/notification/push_notification_service.dart';
import 'package:lamb_talent/ui/custom_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/location_user.dart';
import 'core/routers.dart';
import 'core/routers_names.dart';
import 'core/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final prefs = UserPreferences();
  await prefs.initPrefs();
  prefs.existNotify = false;
  await PushNotificationService.initializeAppFirebase();
  await PushNotificationService.initializeAppOneSingal();
  LocationUser().initLocationUser();
  // Plugin must be initialized before using
  try {
    await FlutterDownloader.initialize(
        debug:
            true // optional: set to false to disable printing logs to console (default: true));
        );
  } catch (e) {
    debugPrint('FlutterDownloader init error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('es', 'PE'),
      ],
      theme: CustomTheme(isDark: false).themeData,
      initialRoute: RoutesName.checkAuth,
      transitionDuration: const Duration(seconds: 0),
      getPages: getRouters(),
    );
  }
}
