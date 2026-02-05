import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';
import 'colors.dart';

/// Sistema de tipografía centralizado para Lamb Talent
///
/// Resuelve el problema de 527+ llamadas inline a GoogleFonts.montserrat()
/// Todos los estilos de texto deben usar esta clase en lugar de crear
/// estilos inline.
///
/// Uso:
/// ```dart
/// Text('Título', style: AppTextStyles.h1)
/// Text('Contenido', style: AppTextStyles.bodyMedium)
/// Text('Label', style: AppTextStyles.labelLarge.withColor(ColorsApp.primary))
/// ```
class AppTextStyles {
  AppTextStyles._(); // Constructor privado

  // ============================================================================
  // DISPLAY - Títulos principales de pantalla
  // ============================================================================

  /// Display 2: 32px, SemiBold (w600)
  /// Uso: Títulos de bienvenida, headlines principales
  /// Ejemplo: "Bienvenido" en login
  static final TextStyle display2 = GoogleFonts.montserrat(
    fontSize: FontSizes.display2,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Display 1: 24px, SemiBold (w600)
  /// Uso: Títulos de pantallas secundarias
  /// Ejemplo: Títulos de modal, secciones principales
  static final TextStyle display1 = GoogleFonts.montserrat(
    fontSize: FontSizes.display1,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ============================================================================
  // HEADINGS - Encabezados jerárquicos
  // ============================================================================

  /// H1: 20px, SemiBold (w600)
  /// Uso: Títulos de sección en pantallas
  /// Ejemplo: "Asistencia", "Justificaciones"
  static final TextStyle h1 = GoogleFonts.montserrat(
    fontSize: FontSizes.xxl,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// H2: 18px, SemiBold (w600)
  /// Uso: Subtítulos, headers de cards
  /// Ejemplo: Títulos de carousel items, card headers
  static final TextStyle h2 = GoogleFonts.montserrat(
    fontSize: FontSizes.xl,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// H3: 16px, Medium (w500)
  /// Uso: Subtítulos menores, labels importantes
  /// Ejemplo: Headers de listas, subsecciones
  static final TextStyle h3 = GoogleFonts.montserrat(
    fontSize: FontSizes.lg,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // ============================================================================
  // BODY - Texto de cuerpo/contenido
  // ============================================================================

  /// Body Large: 16px, Regular (w400)
  /// Uso: Texto de cuerpo enfatizado, contenido principal largo
  /// Ejemplo: Descripciones importantes, contenido de modal
  static final TextStyle bodyLarge = GoogleFonts.montserrat(
    fontSize: FontSizes.lg,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Medium: 14px, Regular (w400)
  /// Uso: Texto de cuerpo estándar (MÁS USADO)
  /// Ejemplo: Contenido general, descripciones, texto de lista
  static final TextStyle bodyMedium = GoogleFonts.montserrat(
    fontSize: FontSizes.md,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Small: 12px, Regular (w400)
  /// Uso: Texto secundario, captions
  /// Ejemplo: Metadata, fechas, información complementaria
  static final TextStyle bodySmall = GoogleFonts.montserrat(
    fontSize: FontSizes.sm,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ============================================================================
  // LABELS - Labels, botones, form fields
  // ============================================================================

  /// Label Large: 14px, Medium (w500)
  /// Uso: Labels de formulario, texto de botones
  /// Ejemplo: "Usuario", "Contraseña", botones de acción
  static final TextStyle labelLarge = GoogleFonts.montserrat(
    fontSize: FontSizes.md,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// Label Medium: 12px, Medium (w500)
  /// Uso: Labels pequeños, badges, chips
  /// Ejemplo: Estados, categorías, tags
  static final TextStyle labelMedium = GoogleFonts.montserrat(
    fontSize: FontSizes.sm,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  /// Label Small: 11px, Medium (w500)
  /// Uso: Labels muy pequeños, indicators
  /// Ejemplo: Contadores, timestamps inline
  static final TextStyle labelSmall = GoogleFonts.montserrat(
    fontSize: FontSizes.xs,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ============================================================================
  // VARIANTS ESPECIALES
  // ============================================================================

  /// Button Text: 14px, Medium (w500)
  /// Uso específico: Texto de botones
  static final TextStyle button = GoogleFonts.montserrat(
    fontSize: FontSizes.md,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Caption: 11px, Regular (w400)
  /// Uso: Captions, ayuda contextual, disclaimer
  static final TextStyle caption = GoogleFonts.montserrat(
    fontSize: FontSizes.xs,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Overline: 11px, Medium (w500), UPPERCASE
  /// Uso: Labels de categoría, overline text
  static final TextStyle overline = GoogleFonts.montserrat(
    fontSize: FontSizes.xs,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 1.5,
  );

  // ============================================================================
  // ESTILOS CON COLOR PREDEFINIDO (más usados)
  // ============================================================================

  /// Display 2 en primary
  static final TextStyle display2Primary = display2.copyWith(color: ColorsApp.primary);

  /// Display 2 en white
  static final TextStyle display2White = display2.copyWith(color: ColorsApp.white);

  /// H1 en primary
  static final TextStyle h1Primary = h1.copyWith(color: ColorsApp.primary);

  /// H1 en white
  static final TextStyle h1White = h1.copyWith(color: ColorsApp.white);

  /// H2 en primary
  static final TextStyle h2Primary = h2.copyWith(color: ColorsApp.primary);

  /// H2 en white
  static final TextStyle h2White = h2.copyWith(color: ColorsApp.white);

  /// Body Medium en neutral900 (texto principal oscuro)
  static final TextStyle bodyMediumDark = bodyMedium.copyWith(color: ColorsApp.neutral900);

  /// Body Medium en neutral600 (texto normal)
  static final TextStyle bodyMediumNormal = bodyMedium.copyWith(color: ColorsApp.neutral600);

  /// Body Small en neutral500 (texto secundario)
  static final TextStyle bodySmallSecondary = bodySmall.copyWith(color: ColorsApp.neutral500);

  /// Label Large en white (para botones sobre fondos oscuros)
  static final TextStyle labelLargeWhite = labelLarge.copyWith(color: ColorsApp.white);

  /// Label Large en primary (para labels de formulario)
  static final TextStyle labelLargePrimary = labelLarge.copyWith(color: ColorsApp.primary);
}

/// Extension helper para aplicar colores fácilmente a cualquier TextStyle
extension TextStyleExtensions on TextStyle {
  /// Aplica un color al estilo actual
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Aplica opacidad al color actual
  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withValues(alpha: opacity));

  /// Aplica peso de fuente
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);

  /// Aplica tamaño de fuente
  TextStyle withSize(double size) => copyWith(fontSize: size);

  /// Aplica altura de línea
  TextStyle withHeight(double height) => copyWith(height: height);

  /// Hace el texto bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Hace el texto semibold
  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);

  /// Hace el texto medium
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Hace el texto regular
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
}
