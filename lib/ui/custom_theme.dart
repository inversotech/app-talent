import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';

class CustomTheme {
  Color bg = ColorsApp.primary;
  Color surface = Colors.white;
  Color primary = ColorsApp.primary;
  Color primaryVariant = ColorsApp.primaryVariant;
  Color accent = const Color(0xff00618E);
  bool isDark = false;
  TextTheme textTheme;

  /// Default constructor
  CustomTheme({required this.isDark, required this.textTheme});

  ThemeData get themeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    Color txtColor = textTheme.bodyText1!.color!;
    ColorScheme colorScheme = ColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        primaryVariant: primaryVariant,
        secondary: accent,
        secondaryVariant: accent,
        background: Colors.white,
        surface: surface,
        onBackground: txtColor,
        onSurface: txtColor,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        error: ColorsApp.danger);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t = ThemeData.from(textTheme: textTheme, colorScheme: colorScheme)
        // We can also add on some extra properties that ColorScheme seems to miss
        .copyWith(
          
            pageTransitionsTheme: PageTransitionsTheme(
              // makes all platforms that can run Flutter apps display routes without any animation
              builders: { for (var k in TargetPlatform.values.toList()) k : const _InanimatePageTransitionsBuilder() },
            ),
            /*buttonTheme: ButtonThemeData(
              colorScheme: colorScheme,
              buttonColor: accent,
              /* disabledColor: disabledColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      materialTapTargetSize: materialTapTargetSize, */
            ),*/
            highlightColor: accent,
            toggleableActiveColor: accent);

    /// Return the themeData which MaterialApp can now use
    return t;
  }
}

/// This class is used to build page transitions that don't have any animation
class _InanimatePageTransitionsBuilder extends PageTransitionsBuilder {
  const _InanimatePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}
