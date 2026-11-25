import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formato_moneda.dart';
import '../../../data/models/producto.dart';
import '../../../widgets/etiqueta_stock.dart';
import '../../../widgets/imagen_plato.dart';
import '../../../widgets/sello_agotado.dart';

/// Tarjeta de producto en el listado de una categoría.
/// Si no hay stock: imagen en gris, sello "SOLD OUT" y botón deshabilitado.
class TarjetaProducto extends StatelessWidget {
  final Producto producto;
  final VoidCallback alTocar;
  final VoidCallback alAgregar;

  const TarjetaProducto({
    super.key,
    required this.producto,
    required this.alTocar,
    required this.alAgregar,
  });

  @override
  Widget build(BuildContext context) {
    final disponible = producto.disponible;
    final colorTexto = disponible ? AppColors.texto : AppColors.agotado;

    return Material(
      color: disponible ? AppColors.superficie : AppColors.agotadoFondo,
      borderRadius: BorderRadius.circular(16),
      elevation: disponible ? 1 : 0,
      shadowColor: const Color(0x22000000),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: disponible ? alTocar : null,
        // Altura fija (rápida de dibujar) que crece si el celular usa letra
        // grande, para que el contenido nunca se desborde.
        child: SizedBox(
          height: 142 * _escalaTexto(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 108,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ImagenPlato(
                      rutas: [producto.imagen],
                      url: producto.imagenUrl(ancho: 300),
                      categoriaId: producto.categoriaId,
                      enGris: !disponible,
                    ),
                    if (!disponible) const Center(child: SelloAgotado()),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        producto.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colorTexto,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        producto.descripcionCorta,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          color: AppColors.textoSecundario,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Stock visible para el cliente
                      EtiquetaStock(producto: producto, compacta: true),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatoPesos(producto.precio),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: disponible
                                    ? AppColors.primario
                                    : AppColors.agotado,
                              ),
                            ),
                          ),
                          _BotonAgregar(
                            alPresionar: disponible ? alAgregar : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cuánto agranda el sistema la letra (1.0 = normal), con un límite.
  static double _escalaTexto(BuildContext context) {
    final escala = MediaQuery.textScalerOf(context).scale(14) / 14;
    return escala.clamp(1.0, 1.6).toDouble();
  }
}

class _BotonAgregar extends StatelessWidget {
  final VoidCallback? alPresionar;

  const _BotonAgregar({required this.alPresionar});

  @override
  Widget build(BuildContext context) {
    final activo = alPresionar != null;
    return Material(
      color: activo ? AppColors.fondo : const Color(0x11000000),
      shape: const CircleBorder(side: BorderSide(color: AppColors.borde)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: alPresionar,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            Icons.add,
            size: 18,
            color: activo ? AppColors.texto : AppColors.agotado,
          ),
        ),
      ),
    );
  }
}
