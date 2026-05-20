import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/text_styles.dart';

/// Componente de texto reutilizable con estilos predefinidos
///
/// Este widget envuelve el widget Text de Flutter y aplica automáticamente
/// los estilos de tipografía centralizados de AppTextStyles.
///
/// Variantes disponibles:
/// - [AppText.display1] / [AppText.display2] - Títulos muy grandes
/// - [AppText.h1] / [AppText.h2] / [AppText.h3] - Encabezados
/// - [AppText.bodyLarge] / [AppText.body] / [AppText.bodySmall] - Texto de cuerpo
/// - [AppText.labelLarge] / [AppText.label] / [AppText.labelSmall] - Labels
///
/// Ejemplo:
/// ```dart
/// AppText.h1('Título Principal')
/// AppText.body('Texto de contenido', color: ColorsApp.neutral600)
/// AppText.label('Label', color: ColorsApp.neutral500)
/// ```
class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const AppText._({
    super.key,
    required this.text,
    required this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  // ============================================================================
  // DISPLAY STYLES - Para títulos muy grandes
  // ============================================================================

  /// Display 1 - Título muy grande (32px, semibold)
  /// Uso: Títulos principales de bienvenida, páginas de destino
  factory AppText.display1(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.display1,
      color: color ?? ColorsApp.neutral900,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Display 2 - Título grande (24px, semibold)
  /// Uso: Subtítulos principales, secciones importantes
  factory AppText.display2(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.display2,
      color: color ?? ColorsApp.neutral900,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // ============================================================================
  // HEADING STYLES - Para encabezados
  // ============================================================================

  /// H1 - Encabezado nivel 1 (20px, semibold)
  /// Uso: Títulos de secciones principales
  factory AppText.h1(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.h1,
      color: color ?? ColorsApp.neutral800,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// H2 - Encabezado nivel 2 (18px, semibold)
  /// Uso: Subtítulos de secciones
  factory AppText.h2(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.h2,
      color: color ?? ColorsApp.neutral800,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// H3 - Encabezado nivel 3 (16px, medium)
  /// Uso: Títulos de cards, subsecciones
  factory AppText.h3(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.h3,
      color: color ?? ColorsApp.neutral700,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // ============================================================================
  // BODY STYLES - Para texto de contenido
  // ============================================================================

  /// Body Large - Texto de cuerpo grande (16px, regular)
  /// Uso: Contenido principal importante, párrafos destacados
  factory AppText.bodyLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.bodyLarge,
      color: color ?? ColorsApp.neutral700,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  /// Body - Texto de cuerpo normal (14px, regular) [DEFAULT]
  /// Uso: Contenido principal, descripciones, párrafos
  factory AppText.body(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.bodyMedium,
      color: color ?? ColorsApp.neutral600,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  /// Body Small - Texto de cuerpo pequeño (12px, regular)
  /// Uso: Notas, metadata, información secundaria
  factory AppText.bodySmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.bodySmall,
      color: color ?? ColorsApp.neutral500,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  // ============================================================================
  // LABEL STYLES - Para labels y botones
  // ============================================================================

  /// Label Large - Label grande (14px, medium)
  /// Uso: Labels importantes, botones
  factory AppText.labelLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.labelLarge,
      color: color ?? ColorsApp.neutral700,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Label - Label normal (12px, medium) [DEFAULT]
  /// Uso: Labels de campos, etiquetas
  factory AppText.label(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.labelMedium,
      color: color ?? ColorsApp.neutral600,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Label Small - Label pequeño (11px, medium)
  /// Uso: Badges, chips, metadata
  factory AppText.labelSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      key: key,
      text: text,
      style: AppTextStyles.labelSmall,
      color: color ?? ColorsApp.neutral500,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: color != null ? style.copyWith(color: color) : style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
