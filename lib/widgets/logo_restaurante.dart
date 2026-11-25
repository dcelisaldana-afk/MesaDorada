import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Logo circular de La Mesa Dorada (plato con cubiertos), como en el splash.
/// Si tienen el logo en imagen, pueden reemplazar este widget por
/// Image.asset('assets/images/logo.png').
class LogoRestaurante extends StatelessWidget {
  final double tamano;

  const LogoRestaurante({super.key, this.tamano = 150});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: const BoxDecoration(
        color: Color(0x33FFFFFF),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(tamano * 0.08),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 6)),
          ],
        ),
        child: Center(
          child: Container(
            width: tamano * 0.52,
            height: tamano * 0.52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primario, width: 2.5),
            ),
            child: Icon(
              Icons.restaurant,
              color: AppColors.primario,
              size: tamano * 0.24,
            ),
          ),
        ),
      ),
    );
  }
}
