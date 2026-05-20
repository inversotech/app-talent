import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';

/// Componente de tarjeta reutilizable con diseño plano
///
/// Este widget proporciona un contenedor con estilos consistentes
/// siguiendo los principios de diseño limpio:
/// - Elevation 0 (diseño plano, sin sombra)
/// - Border radius generoso
/// - Padding interno configurable
/// - Background color personalizable
///
/// Variantes:
/// - [AppCard] - Card estándar con padding medium
/// - [AppCard.compact] - Card con padding small
/// - [AppCard.spacious] - Card con padding large
///
/// Ejemplo:
/// ```dart
/// AppCard(
///   child: Column(
///     children: [
///       AppText.h3('Título'),
///       AppText.body('Contenido de la tarjeta'),
///     ],
///   ),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// Contenido de la card
  final Widget child;

  /// Color de fondo
  final Color backgroundColor;

  /// Padding interno
  final EdgeInsetsGeometry padding;

  /// Margen externo
  final EdgeInsetsGeometry? margin;

  /// Border radius personalizado (si null, usa Radius.lg)
  final double? borderRadius;

  /// Ancho personalizado (si null, se adapta al contenido)
  final double? width;

  /// Altura personalizada (si null, se adapta al contenido)
  final double? height;

  /// Callback cuando se presiona la card (hace la card interactiva)
  final VoidCallback? onTap;

  /// Si mostrar un borde
  final bool showBorder;

  /// Color del borde (si showBorder es true)
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor = ColorsApp.white,
    this.padding = const EdgeInsets.all(Spacing.md),
    this.margin,
    this.borderRadius,
    this.width,
    this.height,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
  });

  /// Card compacta - Padding small (8px)
  /// Uso: Cards pequeñas, items de lista
  factory AppCard.compact({
    Key? key,
    required Widget child,
    Color backgroundColor = ColorsApp.white,
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    double? width,
    double? height,
    VoidCallback? onTap,
    bool showBorder = false,
    Color? borderColor,
  }) {
    return AppCard(
      key: key,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(Spacing.sm),
      margin: margin,
      borderRadius: borderRadius,
      width: width,
      height: height,
      onTap: onTap,
      showBorder: showBorder,
      borderColor: borderColor,
      child: child,
    );
  }

  /// Card espaciosa - Padding large (24px)
  /// Uso: Cards importantes, secciones destacadas
  factory AppCard.spacious({
    Key? key,
    required Widget child,
    Color backgroundColor = ColorsApp.white,
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    double? width,
    double? height,
    VoidCallback? onTap,
    bool showBorder = false,
    Color? borderColor,
  }) {
    return AppCard(
      key: key,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(Spacing.lg),
      margin: margin,
      borderRadius: borderRadius,
      width: width,
      height: height,
      onTap: onTap,
      showBorder: showBorder,
      borderColor: borderColor,
      child: child,
    );
  }

  /// Card con fondo neutral - Para destacar contenido sobre fondo blanco
  /// Uso: Cards alternativas, secciones secundarias
  factory AppCard.neutral({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(Spacing.md),
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    double? width,
    double? height,
    VoidCallback? onTap,
    bool showBorder = false,
  }) {
    return AppCard(
      key: key,
      backgroundColor: ColorsApp.neutral50,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      width: width,
      height: height,
      onTap: onTap,
      showBorder: showBorder,
      child: child,
    );
  }

  /// Card con borde - Para énfasis visual sin fondo
  /// Uso: Cards que necesitan destacar con borde
  factory AppCard.outlined({
    Key? key,
    required Widget child,
    Color borderColor = ColorsApp.neutral300,
    EdgeInsetsGeometry padding = const EdgeInsets.all(Spacing.md),
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      backgroundColor: ColorsApp.white,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      width: width,
      height: height,
      onTap: onTap,
      showBorder: true,
      borderColor: borderColor,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppRadius.lg;

    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: showBorder
            ? Border.all(
                color: borderColor ?? ColorsApp.neutral300,
                width: 1.5,
              )
            : null,
      ),
      child: child,
    );

    // Si hay onTap, envolver en Material + InkWell para efecto ripple
    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: cardContent,
        ),
      );
    }

    // Si hay margin, envolver en Container con margin
    if (margin != null) {
      return Container(
        margin: margin,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
