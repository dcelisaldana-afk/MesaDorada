import 'package:flutter/material.dart';

import '../data/models/producto.dart';

/// Muestra al cliente cuántas unidades quedan de un producto.
///
///   - Verde:   "12 disponibles"
///   - Naranja: "¡Solo quedan 3!"  (stock bajo, 5 o menos)
///   - Rojo:    "Agotado"
///   - Gris:    "No disponible por ahora" (la cocina lo pausó)
///
/// Se actualiza sola cuando la cocina cambia el stock o alguien pide.
class EtiquetaStock extends StatelessWidget {
  final Producto producto;

  /// Versión pequeña para las tarjetas del listado.
  final bool compacta;

  const EtiquetaStock({
    super.key,
    required this.producto,
    this.compacta = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = producto;
    final String texto;
    final Color color;
    final IconData icono;

    if (!p.activo || !p.habilitado) {
      texto = 'No disponible por ahora';
      color = const Color(0xFF757575);
      icono = Icons.pause_circle_outline;
    } else if (p.stock == 0) {
      texto = 'Agotado';
      color = const Color(0xFFB3261E);
      icono = Icons.remove_shopping_cart_outlined;
    } else if (p.stockBajo) {
      texto = p.stock == 1 ? '¡Solo queda 1!' : '¡Solo quedan ${p.stock}!';
      color = const Color(0xFFB26A00);
      icono = Icons.local_fire_department_outlined;
    } else {
      texto = compacta
          ? '${p.stock} disponibles'
          : '${p.stock} unidades disponibles';
      color = const Color(0xFF3E7D3A);
      icono = Icons.inventory_2_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compacta ? 7 : 10, vertical: compacta ? 2 : 5),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: compacta ? 12 : 16, color: color),
          SizedBox(width: compacta ? 3 : 5),
          Flexible(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: compacta ? 11 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
