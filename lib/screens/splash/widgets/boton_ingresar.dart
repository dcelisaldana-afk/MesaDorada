import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Botón blanco "Ingresar" con ícono de cubiertos.
class BotonIngresar extends StatelessWidget {
  final VoidCallback alPresionar;

  const BotonIngresar({super.key, required this.alPresionar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ElevatedButton.icon(
        onPressed: alPresionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primario,
          elevation: 6,
          shadowColor: const Color(0x40000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: const Icon(Icons.restaurant, size: 22),
        label: const Text(
          AppStrings.ingresar,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
