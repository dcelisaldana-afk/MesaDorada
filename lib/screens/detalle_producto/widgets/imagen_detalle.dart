import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formato_moneda.dart';
import '../../../data/models/producto.dart';
import '../../../widgets/imagen_plato.dart';
import '../../../widgets/sello_agotado.dart';

/// Imagen grande del producto con el precio superpuesto.
class ImagenDetalle extends StatelessWidget {
  final Producto producto;

  const ImagenDetalle({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImagenPlato(
            rutas: [producto.imagen],
            url: producto.imagenUrl(ancho: 900),
            categoriaId: producto.categoriaId,
            enGris: !producto.disponible,
            tamanoIcono: 90,
          ),
          if (!producto.disponible)
            const Center(child: SelloAgotado(escala: 1.8)),
          Positioned(
            left: 16,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primario,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x40000000), blurRadius: 8),
                ],
              ),
              child: Text(
                formatoPesos(producto.precio),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
