import 'package:flutter/material.dart';

/// Ícono y colores de respaldo por categoría.
/// Se usan como imagen provisional cuando aún no se ha agregado la foto
/// del plato en assets/images/.
class EstiloCategoria {
  final IconData icono;
  final List<Color> degradado;

  const EstiloCategoria(this.icono, this.degradado);
}

const Map<String, EstiloCategoria> _estilos = {
  'hamburguesas': EstiloCategoria(
      Icons.lunch_dining, [Color(0xFFB5652F), Color(0xFF6E3A1C)]),
  'pizzas': EstiloCategoria(
      Icons.local_pizza, [Color(0xFFD9822B), Color(0xFF9B3D1F)]),
  'ensaladas':
      EstiloCategoria(Icons.eco, [Color(0xFF7FB069), Color(0xFF3F6E3A)]),
  'pastas': EstiloCategoria(
      Icons.ramen_dining, [Color(0xFFE2B45A), Color(0xFFA8742A)]),
  'postres':
      EstiloCategoria(Icons.cake, [Color(0xFF9C6B5A), Color(0xFF4E2E26)]),
  'bebidas': EstiloCategoria(
      Icons.local_drink, [Color(0xFF8CC7B5), Color(0xFF3E8A78)]),
  'sopas': EstiloCategoria(
      Icons.soup_kitchen, [Color(0xFFE07A4F), Color(0xFF9E3B22)]),
  'mariscos':
      EstiloCategoria(Icons.set_meal, [Color(0xFFF0A27A), Color(0xFFB2563A)]),
  'tacos':
      EstiloCategoria(Icons.fastfood, [Color(0xFFE9B949), Color(0xFFA5642A)]),
  'sushi': EstiloCategoria(
      Icons.rice_bowl, [Color(0xFF6F8F8A), Color(0xFF2F4A46)]),
};

const EstiloCategoria _porDefecto = EstiloCategoria(
    Icons.restaurant, [Color(0xFFC95A3C), Color(0xFF8E3A24)]);

EstiloCategoria estiloCategoria(String categoriaId) =>
    _estilos[categoriaId] ?? _porDefecto;
