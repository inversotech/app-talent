import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/text_styles.dart';

/// Sistema de theming completo para Lamb Talent
/// Rediseñado siguiendo Golden Rules for Clean UI Design
///
/// Este archivo centraliza toda la configuración de Material Theme
/// usando la nueva paleta de colores, design tokens y text styles.
class CustomTheme {
  Color bg = ColorsApp.neutral50;
  Color surface = ColorsApp.white;
  Color primary = ColorsApp.primary;
  Color primaryLight = ColorsApp.primaryLight;
  Color accent = ColorsApp.primary; // Usar primary como accent
  bool isDark = false;

  /// Default constructor
  CustomTheme({required this.isDark});

  ThemeData get themeData {
    // =========================================================================
    // COLOR SCHEME - Basado en nueva paleta de colores
    // =========================================================================
    ColorScheme colorScheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,

      // Colores principales
      primary: ColorsApp.primary,
      onPrimary: ColorsApp.white,
      primaryContainer: ColorsApp.primaryLight,
      onPrimaryContainer: ColorsApp.white,

      // Colores secundarios
      secondary: ColorsApp.primaryLight,
      onSecondary: ColorsApp.white,
      secondaryContainer: ColorsApp.neutral100,
      onSecondaryContainer: ColorsApp.neutral900,

      // Colores de superficie
      surface: ColorsApp.white,
      onSurface: ColorsApp.neutral900,
      surfaceContainerLowest: ColorsApp.neutral50,
      surfaceContainerLow: ColorsApp.neutral100,
      surfaceContainer: ColorsApp.neutral200,
      surfaceContainerHigh: ColorsApp.neutral300,
      surfaceContainerHighest: ColorsApp.neutral400,

      // Colores de estado
      error: ColorsApp.danger,
      onError: ColorsApp.white,
      errorContainer: ColorsApp.danger,
      onErrorContainer: ColorsApp.white,

      // Outline y sombras
      outline: ColorsApp.neutral300,
      outlineVariant: ColorsApp.neutral200,
      shadow: ColorsApp.black,
      scrim: ColorsApp.black,

      // Inversed colors
      inverseSurface: ColorsApp.neutral900,
      onInverseSurface: ColorsApp.white,
      inversePrimary: ColorsApp.primaryLight,
    );

    // =========================================================================
    // TEXT THEME - Basado en AppTextStyles
    // =========================================================================
    TextTheme textTheme = TextTheme(
      // Display styles
      displayLarge: AppTextStyles.display2,
      displayMedium: AppTextStyles.display1,
      displaySmall: AppTextStyles.h1,

      // Headline styles
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,

      // Title styles
      titleLarge: AppTextStyles.h2,
      titleMedium: AppTextStyles.h3,
      titleSmall: AppTextStyles.labelLarge,

      // Body styles
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,

      // Label styles
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    );

    // =========================================================================
    // THEME DATA COMPLETO
    // =========================================================================
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,

      // -----------------------------------------------------------------------
      // TYPOGRAPHY
      // -----------------------------------------------------------------------
      fontFamily: 'Montserrat', // Fallback si Google Fonts falla

      // -----------------------------------------------------------------------
      // APP BAR THEME
      // -----------------------------------------------------------------------
      appBarTheme: AppBarTheme(
        elevation: Elevation.none, // Flat design
        backgroundColor: ColorsApp.primary,
        foregroundColor: ColorsApp.white,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h2White,
        toolbarHeight: 64.0,
        iconTheme: const IconThemeData(
          color: ColorsApp.white,
          size: IconSizes.md,
        ),
      ),

      // -----------------------------------------------------------------------
      // CARD THEME
      // -----------------------------------------------------------------------
      cardTheme: CardThemeData(
        elevation: Elevation.none, // Flat design para limpieza visual
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularLg,
        ),
        color: ColorsApp.white,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // -----------------------------------------------------------------------
      // BUTTON THEMES
      // -----------------------------------------------------------------------

      // Filled Button (botones principales)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ColorsApp.primary,
          foregroundColor: ColorsApp.white,
          disabledBackgroundColor: ColorsApp.neutral300,
          disabledForegroundColor: ColorsApp.neutral500,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circularMd,
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(88, 48),
          elevation: Elevation.none,
        ),
      ),

      // Outlined Button (botones secundarios con borde)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorsApp.primary,
          disabledForegroundColor: ColorsApp.neutral400,
          side: const BorderSide(color: ColorsApp.neutral300, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circularMd,
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(88, 48),
        ),
      ),

      // Text Button (botones de texto)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorsApp.primary,
          disabledForegroundColor: ColorsApp.neutral400,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circularSm,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: ColorsApp.primary,
          disabledForegroundColor: ColorsApp.neutral400,
          padding: const EdgeInsets.all(Spacing.sm),
          minimumSize: const Size(48, 48),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorsApp.primary,
        foregroundColor: ColorsApp.white,
        elevation: Elevation.medium,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularMd,
        ),
      ),

      // -----------------------------------------------------------------------
      // INPUT DECORATION THEME (Formularios)
      // -----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorsApp.neutral100,

        // Borders
        border: OutlineInputBorder(
          borderRadius: AppRadius.circularMd,
          borderSide: const BorderSide(color: ColorsApp.neutral300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularMd,
          borderSide: const BorderSide(color: ColorsApp.neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularMd,
          borderSide: const BorderSide(color: ColorsApp.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularMd,
          borderSide: const BorderSide(color: ColorsApp.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularMd,
          borderSide: const BorderSide(color: ColorsApp.danger, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularMd,
          borderSide: const BorderSide(color: ColorsApp.neutral200, width: 1),
        ),

        // Content padding (spacing generoso)
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),

        // Text styles
        labelStyle:
            AppTextStyles.labelLarge.copyWith(color: ColorsApp.neutral700),
        floatingLabelStyle:
            AppTextStyles.labelMedium.copyWith(color: ColorsApp.primary),
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: ColorsApp.neutral400),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: ColorsApp.danger),
        helperStyle:
            AppTextStyles.bodySmall.copyWith(color: ColorsApp.neutral500),

        // Icon colors
        prefixIconColor: ColorsApp.neutral600,
        suffixIconColor: ColorsApp.neutral600,
      ),

      // -----------------------------------------------------------------------
      // CHIP THEME
      // -----------------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: ColorsApp.neutral100,
        disabledColor: ColorsApp.neutral200,
        selectedColor: ColorsApp.primary,
        secondarySelectedColor: ColorsApp.primaryLight,
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md, vertical: Spacing.sm),
        labelStyle: AppTextStyles.labelMedium,
        secondaryLabelStyle:
            AppTextStyles.labelMedium.copyWith(color: ColorsApp.white),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularPill,
        ),
        side: const BorderSide(color: ColorsApp.neutral300, width: 1),
        elevation: Elevation.none,
      ),

      // -----------------------------------------------------------------------
      // DIALOG THEME
      // -----------------------------------------------------------------------
      dialogTheme: DialogThemeData(
        backgroundColor: ColorsApp.white,
        elevation: Elevation.high,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularLg,
        ),
        titleTextStyle: AppTextStyles.h2Primary,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // -----------------------------------------------------------------------
      // BOTTOM SHEET THEME
      // -----------------------------------------------------------------------
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ColorsApp.white,
        elevation: Elevation.high,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.0), // AppRadius.lg value
            topRight: Radius.circular(28.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // -----------------------------------------------------------------------
      // DIVIDER THEME
      // -----------------------------------------------------------------------
      dividerTheme: const DividerThemeData(
        color: ColorsApp.neutral200,
        thickness: 1,
        space: Spacing.md,
      ),

      // -----------------------------------------------------------------------
      // CHECKBOX, RADIO, SWITCH THEMES
      // -----------------------------------------------------------------------
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorsApp.primary;
          }
          return ColorsApp.neutral300;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm / 2),
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorsApp.primary;
          }
          return ColorsApp.neutral300;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorsApp.primary;
          }
          return ColorsApp.neutral300;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorsApp.primaryLight;
          }
          return ColorsApp.neutral200;
        }),
      ),

      // -----------------------------------------------------------------------
      // MISC
      // -----------------------------------------------------------------------
      highlightColor: ColorsApp.primaryLight.withValues(alpha: 0.1),
      splashColor: ColorsApp.primaryLight.withValues(alpha: 0.2),

      // Sin animaciones en transiciones de página (requisito del proyecto)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _InanimatePageTransitionsBuilder(),
          TargetPlatform.iOS: _InanimatePageTransitionsBuilder(),
          TargetPlatform.fuchsia: _InanimatePageTransitionsBuilder(),
          TargetPlatform.linux: _InanimatePageTransitionsBuilder(),
          TargetPlatform.macOS: _InanimatePageTransitionsBuilder(),
          TargetPlatform.windows: _InanimatePageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Builder de transiciones de página sin animación
/// Requisito del proyecto: transitionDuration: 0
class _InanimatePageTransitionsBuilder extends PageTransitionsBuilder {
  const _InanimatePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // Sin animación
  }
}
