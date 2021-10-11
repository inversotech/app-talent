import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/constants/routers.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/app_route_observer.dart';
import 'package:upn_financiero_mobil/src/theme/custom_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  /*  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  }; */
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String FontNameDefault = 'Montserrat';
    const Body1Style = TextStyle(
      fontFamily: FontNameDefault,
      fontWeight: FontWeight.w300,
      fontSize: 14.0,
      color: ColorsApp.primary,
    );
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
      ],
      theme: CustomTheme(
              isDark: false, textTheme: TextTheme(bodyText1: Body1Style))
          .themeData,
      navigatorObservers: [AppRouteObserver()],
      initialRoute: 'check-auth',
      routes: getRouters(),
    );
  }
}
