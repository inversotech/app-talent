import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/resources/services/notification/push_notification_service.dart';
import 'package:lamb_talent/ui/custom_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/colors.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const body1Style = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 14.0,
      color: ColorsApp.primary,
    );
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
      theme: CustomTheme(
              isDark: false, textTheme: const TextTheme(bodyText1: body1Style))
          .themeData,
      initialRoute: RoutesName.checkAuth,
      transitionDuration: const Duration(seconds: 0),
      getPages: getRouters(),
    );
  }
}
