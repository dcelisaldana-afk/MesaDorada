import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formato_moneda.dart';
import '../../../data/models/item_carrito.dart';
import '../../../widgets/imagen_plato.dart';
import '../../../widgets/selector_cantidad.dart';

/// Producto dentro del carrito: imagen, nombre, cantidad, precio y
/// botón para eliminar.
class ItemCarritoTile extends StatelessWidget {
  final ItemCarrito item;
  final VoidCallback alAumentar;
  final VoidCallback alDisminuir;
  final VoidCallback alEliminar;

  const ItemCarritoTile({
    super.key,
    required this.item,
    required this.alAumentar,
    required this.alDisminuir,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final producto = item.producto;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 72,
              child: ImagenPlato(
                rutas: [producto.imagen],
                url: producto.imagenUrl(ancho: 200),
                categoriaId: producto.categoriaId,
                tamanoIcono: 30,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        producto.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.texto,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: alEliminar,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.delete_outline,
                            size: 20, color: AppColors.texto),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SelectorCantidad(
                      cantidad: item.cantidad,
                      tamanoBoton: 26,
                      alDisminuir: alDisminuir,
                      alAumentar: item.cantidad < producto.stock
                          ? alAumentar
                          : null,
                    ),
                    const Spacer(),
                    Text(
                      formatoPesos(item.subtotal),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primario,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
