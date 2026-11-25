import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/categoria.dart';
import '../../../widgets/imagen_plato.dart';

/// Tarjeta de la cuadrícula de categorías (imagen + nombre + flecha).
class TarjetaCategoria extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback alTocar;

  const TarjetaCategoria({
    super.key,
    required this.categoria,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.superficie,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: const Color(0x22000000),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alTocar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ImagenPlato(
                rutas: [categoria.imagen],
                url: categoria.imagenUrl(ancho: 400),
                categoriaId: categoria.id,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 9, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      categoria.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.texto,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      size: 20, color: AppColors.primario),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
