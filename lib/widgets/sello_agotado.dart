import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

/// Sello diagonal "SOLD OUT" para productos sin stock.
class SelloAgotado extends StatelessWidget {
  final double escala;

  const SelloAgotado({super.key, this.escala = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.35,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 10 * escala, vertical: 4 * escala),
        decoration: BoxDecoration(
          color: AppColors.primario,
          borderRadius: BorderRadius.circular(6 * escala),
          boxShadow: const [
            BoxShadow(color: Color(0x40000000), blurRadius: 6),
          ],
        ),
        child: Text(
          AppStrings.agotado,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11 * escala,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
