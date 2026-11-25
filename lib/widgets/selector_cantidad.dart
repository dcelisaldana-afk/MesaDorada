import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Contador  (−) 1 (+)  usado en Detalle de Producto y en el Carrito.
class SelectorCantidad extends StatelessWidget {
  final int cantidad;
  final VoidCallback? alDisminuir;
  final VoidCallback? alAumentar;
  final double tamanoBoton;

  const SelectorCantidad({
    super.key,
    required this.cantidad,
    required this.alDisminuir,
    required this.alAumentar,
    this.tamanoBoton = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Boton(icono: Icons.remove, alPresionar: alDisminuir, tamano: tamanoBoton),
        SizedBox(
          width: 34,
          child: Text(
            '$cantidad',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.texto),
          ),
        ),
        _Boton(icono: Icons.add, alPresionar: alAumentar, tamano: tamanoBoton),
      ],
    );
  }
}

class _Boton extends StatelessWidget {
  final IconData icono;
  final VoidCallback? alPresionar;
  final double tamano;

  const _Boton({
    required this.icono,
    required this.alPresionar,
    required this.tamano,
  });

  @override
  Widget build(BuildContext context) {
    final activo = alPresionar != null;
    return Material(
      color: AppColors.fondo,
      shape: const CircleBorder(side: BorderSide(color: AppColors.borde)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: alPresionar,
        child: SizedBox(
          width: tamano,
          height: tamano,
          child: Icon(icono,
              size: tamano * 0.55,
              color: activo ? AppColors.texto : AppColors.agotado),
        ),
      ),
    );
  }
}
