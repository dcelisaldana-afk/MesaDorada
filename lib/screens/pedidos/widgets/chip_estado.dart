import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/pedido.dart';

/// Etiqueta de color con el estado del pedido.
class ChipEstado extends StatelessWidget {
  final EstadoPedido estado;

  const ChipEstado({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final entregado = estado == EstadoPedido.entregado;
    final color = entregado ? AppColors.exito : AppColors.primario;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: entregado ? const Color(0x1F4F9A5B) : const Color(0x1FC95A3C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(estado.icono, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            estado.titulo,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
