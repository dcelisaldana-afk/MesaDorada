import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Etiqueta verde de ingrediente ("Carne de res", "Lechuga", ...).
class ChipIngrediente extends StatelessWidget {
  final String texto;

  const ChipIngrediente({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chipFondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: AppColors.chipTexto,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
