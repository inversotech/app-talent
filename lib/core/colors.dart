import 'package:flutter/material.dart';

/// Sistema de colores rediseñado siguiendo principios de diseño limpio 2026
/// Basado en TailwindCSS v3 + Golden Rules for Clean UI Design
///
/// Principio: Diseñar en gris primero (80% neutrales, 15% primary, 5% semantic)
class ColorsApp {
  // ============================================================================
  // COLORES PRINCIPALES
  // ============================================================================

  /// Primary: Indigo moderno (reemplaza el azul muy oscuro anterior #0D1F33)
  /// Uso: Botones principales, headers, elementos de marca
  /// Contraste: WCAG AAA sobre blanco
  static const Color primary = Color(0xFF1E40AF); // Indigo-700

  /// Primary Light: Para estados hover/activos
  /// Uso: Botones hover, elementos interactivos, gradientes
  static const Color primaryLight = Color(0xFF3B82F6); // Blue-500

  /// Primary Dark: Para énfasis adicional
  /// Uso: Texto sobre fondos claros, estados pressed
  static const Color primaryDark = Color(0xFF1E3A8A); // Blue-900

  // ============================================================================
  // COLORES SEMÁNTICOS
  // ============================================================================

  /// Success: Verde vibrante para estados positivos
  /// Uso: Confirmaciones, aprobaciones, estados exitosos
  static const Color success = Color(0xFF10B981); // Emerald-500

  /// Danger: Rojo para errores y acciones destructivas
  /// Uso: Errores, rechazos, eliminaciones
  static const Color danger = Color(0xFFEF4444); // Red-500

  /// Warning: Naranja para alertas y advertencias
  /// Uso: Advertencias, información importante que requiere atención
  static const Color warning = Color(0xFFF59E0B); // Amber-500

  // ============================================================================
  // ESCALA DE NEUTRALES (Clave para diseño limpio)
  // ============================================================================

  /// Neutral 50: Fondo más sutil
  /// Uso: Fondos de página, fondos sutiles, gradientes
  static const Color neutral50 = Color(0xFFF8FAFC); // Slate-50

  /// Neutral 100: Fondos de cards alternos
  /// Uso: Cards, contenedores, fondos secundarios
  static const Color neutral100 = Color(0xFFF1F5F9); // Slate-100

  /// Neutral 200: Bordes suaves
  /// Uso: Bordes de inputs deshabilitados, divisores sutiles
  static const Color neutral200 = Color(0xFFE2E8F0); // Slate-200

  /// Neutral 300: Bordes normales
  /// Uso: Bordes de inputs, divisores, separadores
  static const Color neutral300 = Color(0xFFCBD5E1); // Slate-300

  /// Neutral 400: Placeholders y estados deshabilitados
  /// Uso: Texto placeholder, iconos deshabilitados
  static const Color neutral400 = Color(0xFF94A3B8); // Slate-400

  /// Neutral 500: Texto secundario
  /// Uso: Texto de ayuda, labels secundarios, metadata
  static const Color neutral500 = Color(0xFF64748B); // Slate-500

  /// Neutral 600: Texto normal
  /// Uso: Texto de cuerpo, contenido principal
  static const Color neutral600 = Color(0xFF475569); // Slate-600

  /// Neutral 700: Texto prominente
  /// Uso: Texto importante, labels activos
  static const Color neutral700 = Color(0xFF334155); // Slate-700

  /// Neutral 800: Headings
  /// Uso: Títulos, encabezados, texto de alta jerarquía
  static const Color neutral800 = Color(0xFF1E293B); // Slate-800

  /// Neutral 900: Texto principal oscuro
  /// Uso: Títulos principales, texto de máxima prioridad
  static const Color neutral900 = Color(0xFF0F172A); // Slate-900

  // ============================================================================
  // COLORES BASE
  // ============================================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ============================================================================
  // COLORES DEPRECADOS (mantener por compatibilidad temporal)
  // ============================================================================

  /// @deprecated Usar neutral200 en su lugar
  static const Color info = Color(0xFFE2E8F0); // Reemplazado por neutral200

  /// @deprecated Usar neutral500 en su lugar
  static const Color control = Color(0xFF64748B); // Reemplazado por neutral500

  /// @deprecated Color nunca usado, será removido
  static const Color secondary = Color(0xFFF5DBDE); // Rosa - deprecado

  /// @deprecated Usar primaryLight en su lugar
  static const Color primaryVariant = Color(0xFF3B82F6); // Reemplazado por primaryLight

  /// @deprecated Color nunca usado, será removido
  static const Color basic = Color(0xFFBBDECC); // Verde claro - deprecado
}
