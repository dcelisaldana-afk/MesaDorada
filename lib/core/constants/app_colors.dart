import 'package:flutter/material.dart';

/// Paleta de colores tomada del prototipo interactivo de Figma.
/// Si el diseño cambia, basta con editar los valores aquí.
class AppColors {
  AppColors._();

  /// Terracota principal (splash, botones, precios).
  static const Color primario = Color(0xFFC95A3C);
  static const Color primarioOscuro = Color(0xFFA9452B);

  /// Fondo crema de todas las pantallas internas.
  static const Color fondo = Color(0xFFF8F1EB);
  static const Color superficie = Colors.white;

  static const Color texto = Color(0xFF2B2522);
  static const Color textoSecundario = Color(0xFF8A817C);
  static const Color borde = Color(0xFFEDE4DD);

  /// Chips de ingredientes (verde suave).
  static const Color chipFondo = Color(0xFFE9F2E6);
  static const Color chipTexto = Color(0xFF4F7A45);

  /// Estrellas de "Reséñanos".
  static const Color estrella = Color(0xFFF2B640);

  /// Producto agotado.
  static const Color agotado = Color(0xFF9E9E9E);
  static const Color agotadoFondo = Color(0xFFE6E4E2);

  static const Color exito = Color(0xFF4F9A5B);
}
