import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Tema global de la aplicación.
class AppTheme {
  AppTheme._();

  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: AppColors.primario,
      primary: AppColors.primario,
      surface: AppColors.superficie,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: AppColors.fondo,
      splashFactory: InkRipple.splashFactory,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.texto,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.texto,
        ),
        bodyMedium: TextStyle(color: AppColors.texto),
      ),
    );
  }
}
