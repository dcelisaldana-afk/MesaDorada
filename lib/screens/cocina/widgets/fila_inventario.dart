import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/producto.dart';
import '../../../widgets/imagen_plato.dart';
import '../../../widgets/selector_cantidad.dart';

/// Fila del inventario: foto, nombre, stock editable (− / número / +) e
/// interruptor de disponibilidad.
class FilaInventario extends StatelessWidget {
  final Producto producto;
  final String categoria;
  final VoidCallback alSumar;
  final VoidCallback? alRestar;
  final VoidCallback alEditarStock;
  final ValueChanged<bool> alCambiarDisponible;

  const FilaInventario({
    super.key,
    required this.producto,
    required this.categoria,
    required this.alSumar,
    required this.alRestar,
    required this.alEditarStock,
    required this.alCambiarDisponible,
  });

  @override
  Widget build(BuildContext context) {
    final p = producto;
    final agotado = p.stock == 0;
    final String? aviso = !p.habilitado
        ? 'No disponible'
        : agotado
            ? 'Agotado'
            : p.stockBajo
                ? 'Stock bajo'
                : null;
    final colorAviso = !p.habilitado || agotado
        ? const Color(0xFFB3261E)
        : const Color(0xFFB26A00);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: aviso == null ? AppColors.borde : colorAviso.withAlpha(90),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 54,
              height: 54,
              child: ImagenPlato(
                rutas: [p.imagen],
                url: p.imagenUrl(ancho: 150),
                categoriaId: p.categoriaId,
                enGris: !p.disponible,
                tamanoIcono: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14.5),
                ),
                Text(
                  categoria,
                  style: const TextStyle(
                      color: AppColors.textoSecundario, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SelectorCantidad(
                      cantidad: p.stock,
                      tamanoBoton: 26,
                      alDisminuir: alRestar,
                      alAumentar: alSumar,
                    ),
                    IconButton(
                      tooltip: 'Escribir cantidad',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: alEditarStock,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Switch(
                value: p.habilitado,
                activeTrackColor: AppColors.exito,
                onChanged: alCambiarDisponible,
              ),
              Text(
                p.habilitado ? 'Disponible' : 'Pausado',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textoSecundario),
              ),
              if (aviso != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorAviso.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    aviso,
                    style: TextStyle(
                      color: colorAviso,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
