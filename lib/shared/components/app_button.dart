import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/text_styles.dart';

/// Componente de botón reutilizable con variantes predefinidas
///
/// Variantes disponibles:
/// - [AppButton.primary] - Botón principal con color primary
/// - [AppButton.secondary] - Botón secundario con tono neutral
/// - [AppButton.outlined] - Botón con borde sin relleno
/// - [AppButton.text] - Botón de solo texto sin fondo
/// - [AppButton.danger] - Botón para acciones destructivas
///
/// Ejemplo:
/// ```dart
/// AppButton.primary(
///   text: 'Guardar',
///   onPressed: () => print('Guardado'),
///   icon: Icons.save,
/// )
/// ```
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool fullWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final bool outlined;
  final bool isTextButton;

  const AppButton._({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.outlined = false,
    this.isTextButton = false,
  });

  /// Botón principal - Color primary, alta prominencia
  /// Uso: Acciones principales (guardar, enviar, confirmar)
  factory AppButton.primary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return AppButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      loading: loading,
      fullWidth: fullWidth,
      backgroundColor: ColorsApp.primary,
      foregroundColor: ColorsApp.white,
    );
  }

  /// Botón secundario - Tono neutral, menor prominencia que primary
  /// Uso: Acciones secundarias (cancelar, volver, opciones)
  factory AppButton.secondary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return AppButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      loading: loading,
      fullWidth: fullWidth,
      backgroundColor: ColorsApp.neutral200,
      foregroundColor: ColorsApp.neutral900,
    );
  }

  /// Botón con borde - Sin relleno, solo borde
  /// Uso: Acciones terciarias, opciones alternativas
  factory AppButton.outlined({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool loading = false,
    bool fullWidth = false,
    Color? borderColor,
  }) {
    return AppButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      loading: loading,
      fullWidth: fullWidth,
      backgroundColor: Colors.transparent,
      foregroundColor: borderColor ?? ColorsApp.primary,
      borderColor: borderColor ?? ColorsApp.primary,
      outlined: true,
    );
  }

  /// Botón de texto - Solo texto, sin fondo ni borde
  /// Uso: Enlaces, acciones de baja prioridad
  factory AppButton.text({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return AppButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      loading: loading,
      fullWidth: fullWidth,
      backgroundColor: Colors.transparent,
      foregroundColor: ColorsApp.primary,
      isTextButton: true,
    );
  }

  /// Botón danger - Color rojo, para acciones destructivas
  /// Uso: Eliminar, rechazar, deshacer acciones críticas
  factory AppButton.danger({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return AppButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      loading: loading,
      fullWidth: fullWidth,
      backgroundColor: ColorsApp.danger,
      foregroundColor: ColorsApp.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || loading;

    // Determinar el color de fondo según el estado
    final Color effectiveBackgroundColor = isDisabled
        ? (isTextButton ? Colors.transparent : ColorsApp.neutral200)
        : backgroundColor;

    // Determinar el color del texto según el estado
    final Color effectiveForegroundColor =
        isDisabled ? ColorsApp.neutral400 : foregroundColor;

    // Determinar el padding según si tiene icono o no
    final EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: icon != null ? Spacing.lg : Spacing.xl,
      vertical: Spacing.md,
    );

    // Contenido del botón
    Widget buttonChild;
    if (loading) {
      buttonChild = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
        ),
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: effectiveForegroundColor),
          const SizedBox(width: Spacing.sm),
          Text(
            text,
            style: AppTextStyles.labelLarge.copyWith(
              color: effectiveForegroundColor,
            ),
          ),
        ],
      );
    } else {
      buttonChild = Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(
          color: effectiveForegroundColor,
        ),
        textAlign: TextAlign.center,
      );
    }

    // Widget base del botón
    Widget button = Material(
      color: effectiveBackgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: padding,
          decoration: outlined
              ? BoxDecoration(
                  border: Border.all(
                    color: isDisabled
                        ? ColorsApp.neutral300
                        : (borderColor ?? ColorsApp.primary),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                )
              : null,
          child: buttonChild,
        ),
      ),
    );

    // Si fullWidth, envolver en SizedBox con width máximo
    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
