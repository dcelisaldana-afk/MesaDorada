import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/pedido.dart';
import '../../../providers/carrito_provider.dart';

/// Autoservicio: el cliente elige si come en el local o lo lleva.
/// En ambos casos recoge el pedido en la barra con su número de turno.
class SelectorTipoEntrega extends StatelessWidget {
  const SelectorTipoEntrega({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borde),
      ),
      child: Row(
        children: [
          _Opcion(
            icono: Icons.restaurant,
            texto: AppStrings.comerAqui,
            activa: carrito.tipoEntrega == Pedido.tipoComerAqui,
            alTocar: () => carrito.elegirTipoEntrega(Pedido.tipoComerAqui),
          ),
          _Opcion(
            icono: Icons.shopping_bag_outlined,
            texto: AppStrings.paraLlevar,
            activa: carrito.tipoEntrega == Pedido.tipoParaLlevar,
            alTocar: () => carrito.elegirTipoEntrega(Pedido.tipoParaLlevar),
          ),
        ],
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activa;
  final VoidCallback alTocar;

  const _Opcion({
    required this.icono,
    required this.texto,
    required this.activa,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    final color = activa ? Colors.white : AppColors.texto;
    return Expanded(
      child: GestureDetector(
        onTap: alTocar,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: activa ? AppColors.primario : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                texto,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
