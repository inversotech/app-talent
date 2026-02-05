import 'package:flutter/material.dart';

/// Design Tokens para Lamb Talent
/// Sistema de diseño basado en principios de "Golden Rules for Clean UI Design"
///
/// Este archivo centraliza todos los valores de spacing, border radius y tamaños
/// de fuente para mantener consistencia visual en toda la aplicación.
///
/// Uso:
/// ```dart
/// Padding(padding: EdgeInsets.all(Spacing.md))
/// BorderRadius.circular(Radius.lg)
/// Text('Hello', style: TextStyle(fontSize: FontSizes.lg))
/// ```

// ==============================================================================
// SPACING SYSTEM (Base 8px)
// ==============================================================================

/// Sistema de espaciado base 8px siguiendo Material Design spacing scale
///
/// Regla: Usar múltiplos de 4px (xs) y 8px (sm-xxl) para mantener
/// alineación pixel-perfect en todas las densidades de pantalla
class Spacing {
  Spacing._(); // Constructor privado para prevenir instanciación

  /// Extra Small: 4px
  /// Uso: Gaps mínimos entre elementos relacionados (badges, chips)
  static const double xs = 4.0;

  /// Small: 8px
  /// Uso: Gaps pequeños dentro de componentes, padding interno de chips
  static const double sm = 8.0;

  /// Medium: 16px
  /// Uso: Padding estándar de componentes, gaps entre elementos
  static const double md = 16.0;

  /// Large: 24px
  /// Uso: Padding de pantallas, gaps entre secciones, margins generosos
  static const double lg = 24.0;

  /// Extra Large: 32px
  /// Uso: Padding de formularios importantes, separación entre bloques mayores
  static const double xl = 32.0;

  /// Extra Extra Large: 48px
  /// Uso: Separación entre secciones principales, headers grandes
  static const double xxl = 48.0;

  /// Helper: EdgeInsets simétrico con valor md
  static const EdgeInsets paddingMd = EdgeInsets.all(Spacing.md);

  /// Helper: EdgeInsets simétrico con valor lg
  static const EdgeInsets paddingLg = EdgeInsets.all(Spacing.lg);

  /// Helper: EdgeInsets horizontal md
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: Spacing.md);

  /// Helper: EdgeInsets horizontal lg
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: Spacing.lg);

  /// Helper: EdgeInsets vertical md
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: Spacing.md);

  /// Helper: EdgeInsets vertical lg
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: Spacing.lg);
}

// ==============================================================================
// BORDER RADIUS SYSTEM
// ==============================================================================

/// Sistema de border radius para mantener consistencia en corners redondeados
///
/// Regla: Usar valores consistentes en toda la app para crear cohesión visual
class Radius {
  Radius._(); // Constructor privado

  /// Small: 12px
  /// Uso: Botones pequeños, chips, badges, inputs compactos
  static const double sm = 12.0;

  /// Medium: 20px
  /// Uso: Cards estándar, modales, sheets
  static const double md = 20.0;

  /// Large: 28px
  /// Uso: Contenedores principales (AppScreen, SecondaryScreen), cards grandes
  static const double lg = 28.0;

  /// Pill: 50px (aproximación a círculo perfecto)
  /// Uso: Botones pill-shaped, inputs redondeados, tags alargados
  static const double pill = 50.0;

  /// Helper: BorderRadius circular sm
  static final BorderRadius circularSm = BorderRadius.circular(Radius.sm);

  /// Helper: BorderRadius circular md
  static final BorderRadius circularMd = BorderRadius.circular(Radius.md);

  /// Helper: BorderRadius circular lg
  static final BorderRadius circularLg = BorderRadius.circular(Radius.lg);

  /// Helper: BorderRadius circular pill
  static final BorderRadius circularPill = BorderRadius.circular(Radius.pill);
}

// ==============================================================================
// TYPOGRAPHY SCALE
// ==============================================================================

/// Escala tipográfica consistente basada en sistema de 4px
///
/// Regla: Usar saltos de 2-4px entre tamaños para crear jerarquía clara
/// pero no exagerada
class FontSizes {
  FontSizes._(); // Constructor privado

  /// Extra Small: 11px
  /// Uso: Captions muy pequeños, timestamps, metadata poco importante
  static const double xs = 11.0;

  /// Small: 12px
  /// Uso: Captions, labels secundarios, ayuda contextual
  static const double sm = 12.0;

  /// Medium: 14px
  /// Uso: Texto de cuerpo estándar, botones, labels principales
  static const double md = 14.0;

  /// Large: 16px
  /// Uso: Texto de cuerpo enfatizado, subtítulos
  static const double lg = 16.0;

  /// Extra Large: 18px
  /// Uso: Subtítulos importantes, card headers
  static const double xl = 18.0;

  /// Extra Extra Large: 20px
  /// Uso: Títulos de sección (h1)
  static const double xxl = 20.0;

  /// Display 1: 24px
  /// Uso: Títulos de pantalla secundarios
  static const double display1 = 24.0;

  /// Display 2: 32px
  /// Uso: Títulos principales de bienvenida, headlines
  static const double display2 = 32.0;
}

// ==============================================================================
// ELEVATION SYSTEM (Material Design)
// ==============================================================================

/// Sistema de elevación para sombras y profundidad
///
/// Nota: Para diseño limpio, preferir elevation 0 (flat) y usar
/// border/color para separación visual
class Elevation {
  Elevation._(); // Constructor privado

  /// Flat: Sin elevación (RECOMENDADO para diseño limpio)
  static const double none = 0.0;

  /// Subtle: Elevación muy sutil
  static const double subtle = 1.0;

  /// Low: Elevación baja para hover states
  static const double low = 2.0;

  /// Medium: Elevación media para modales
  static const double medium = 4.0;

  /// High: Elevación alta para floating elements
  static const double high = 8.0;
}

// ==============================================================================
// ICON SIZES
// ==============================================================================

/// Tamaños estándar para iconos
class IconSizes {
  IconSizes._(); // Constructor privado

  /// Small: 16px
  /// Uso: Iconos inline con texto, indicators
  static const double sm = 16.0;

  /// Medium: 24px (Material Design estándar)
  /// Uso: Iconos de botones, app bar icons
  static const double md = 24.0;

  /// Large: 32px
  /// Uso: Iconos destacados, FABs
  static const double lg = 32.0;

  /// Extra Large: 48px
  /// Uso: Iconos hero, empty states
  static const double xl = 48.0;
}

// ==============================================================================
// ANIMATION DURATIONS
// ==============================================================================

/// Duraciones estándar para animaciones
class AnimationDurations {
  AnimationDurations._(); // Constructor privado

  /// Fast: 150ms
  /// Uso: Micro-interacciones, hover states
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal: 300ms
  /// Uso: Transiciones estándar, modals, sheets
  static const Duration normal = Duration(milliseconds: 300);

  /// Slow: 500ms
  /// Uso: Transiciones complejas, page transitions
  static const Duration slow = Duration(milliseconds: 500);
}
