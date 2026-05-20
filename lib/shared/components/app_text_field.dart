import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/text_styles.dart';

/// Componente de campo de texto reutilizable con estilos consistentes
///
/// Este widget envuelve TextFormField y aplica automáticamente los estilos
/// del sistema de diseño (border radius, padding, colores, etc.).
///
/// Soporta todos los estados estándar:
/// - Normal (idle)
/// - Focused (enfocado)
/// - Error (con mensaje de error)
/// - Disabled (deshabilitado)
///
/// Ejemplo:
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hintText: 'tu@email.com',
///   prefixIcon: Icons.email,
///   keyboardType: TextInputType.emailAddress,
///   validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
/// )
/// ```
class AppTextField extends StatelessWidget {
  /// Label del campo (se muestra encima del input)
  final String? label;

  /// Texto de ayuda que aparece cuando el campo está vacío
  final String? hintText;

  /// Controlador del campo (opcional, se puede omitir)
  final TextEditingController? controller;

  /// Función de validación (retorna null si es válido, mensaje de error si no)
  final String? Function(String?)? validator;

  /// Callback cuando cambia el texto
  final void Function(String)? onChanged;

  /// Callback cuando se envía el formulario (Enter)
  final void Function(String)? onFieldSubmitted;

  /// Callback cuando se completa la edición
  final void Function(String?)? onSaved;

  /// Icono que aparece al inicio del campo
  final IconData? prefixIcon;

  /// Widget personalizado que aparece al inicio del campo
  final Widget? prefixWidget;

  /// Icono que aparece al final del campo
  final IconData? suffixIcon;

  /// Widget personalizado que aparece al final del campo
  final Widget? suffixWidget;

  /// Callback cuando se presiona el icono de sufijo
  final VoidCallback? onSuffixIconPressed;

  /// Tipo de teclado a mostrar
  final TextInputType? keyboardType;

  /// Acción del botón de enter en el teclado
  final TextInputAction? textInputAction;

  /// Indica si el campo es para contraseña (oculta texto)
  final bool obscureText;

  /// Indica si el campo está habilitado
  final bool enabled;

  /// Indica si el campo es de solo lectura
  final bool readOnly;

  /// Número máximo de líneas (null = ilimitado)
  final int? maxLines;

  /// Número mínimo de líneas
  final int minLines;

  /// Longitud máxima del texto
  final int? maxLength;

  /// Autovalidación
  final AutovalidateMode? autovalidateMode;

  /// Focus node personalizado
  final FocusNode? focusNode;

  /// Formatters de entrada
  final List<TextInputFormatter>? inputFormatters;

  /// Capitalización automática
  final TextCapitalization textCapitalization;

  /// Valor inicial del campo
  final String? initialValue;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.autovalidateMode,
    this.focusNode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (si existe)
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.labelMedium.copyWith(
              color: enabled ? ColorsApp.neutral700 : ColorsApp.neutral400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Spacing.xs),
        ],

        // Campo de texto
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          autovalidateMode: autovalidateMode,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: AppTextStyles.bodyMedium.copyWith(
            color: enabled ? ColorsApp.neutral900 : ColorsApp.neutral400,
          ),
          decoration: InputDecoration(
            // Hint text
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: ColorsApp.neutral400,
            ),

            // Prefix (icono o widget personalizado)
            prefixIcon: prefixWidget ??
                (prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color: enabled
                            ? ColorsApp.neutral500
                            : ColorsApp.neutral400,
                        size: 20,
                      )
                    : null),

            // Suffix (icono o widget personalizado)
            suffixIcon: suffixWidget ??
                (suffixIcon != null
                    ? IconButton(
                        icon: Icon(
                          suffixIcon,
                          color: enabled
                              ? ColorsApp.neutral500
                              : ColorsApp.neutral400,
                          size: 20,
                        ),
                        onPressed: onSuffixIconPressed,
                      )
                    : null),

            // Contador de caracteres (si maxLength está definido)
            counterText: maxLength != null ? '' : null,

            // Content padding (padding interno generoso)
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.md,
            ),

            // Borde en estado normal
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: ColorsApp.neutral300,
                width: 1.5,
              ),
            ),

            // Borde cuando está habilitado
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: ColorsApp.neutral300,
                width: 1.5,
              ),
            ),

            // Borde cuando está enfocado
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: ColorsApp.primary,
                width: 2,
              ),
            ),

            // Borde cuando hay error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: ColorsApp.danger,
                width: 1.5,
              ),
            ),

            // Borde cuando está enfocado con error
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: ColorsApp.danger,
                width: 2,
              ),
            ),

            // Borde cuando está deshabilitado
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: ColorsApp.neutral200,
                width: 1.5,
              ),
            ),

            // Color de fondo cuando está deshabilitado
            filled: !enabled,
            fillColor: ColorsApp.neutral100,

            // Estilo del texto de error
            errorStyle: AppTextStyles.bodySmall.copyWith(
              color: ColorsApp.danger,
            ),

            // Padding del texto de error
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
