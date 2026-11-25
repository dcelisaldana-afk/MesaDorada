import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../providers/carrito_provider.dart';
import '../../providers/catalogo_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/boton_carrito.dart';
import '../../widgets/estado_carga.dart';
import '../../widgets/mensajes.dart';
import 'widgets/tarjeta_producto.dart';

/// 3. Pantalla de Menú por Categoría (una sola pantalla para las 10
/// categorías; solo cambia el contenido).
class CategoriaScreen extends StatelessWidget {
  final String categoriaId;

  const CategoriaScreen({super.key, required this.categoriaId});

  @override
  Widget build(BuildContext context) {
    final catalogo = context.watch<CatalogoProvider>();
    final categoria = catalogo.categoria(categoriaId);
    final productos = catalogo.productosDe(categoriaId);

    return Scaffold(
      appBar: BarraSuperior(titulo: categoria?.nombre ?? ''),
      bottomNavigationBar: const BotonCarrito(),
      body: productos.isEmpty
          ? const MensajeVacio(
              icono: Icons.no_food_outlined,
              titulo: 'Sin productos',
              subtitulo: 'Esta categoría aún no tiene platos.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: productos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final producto = productos[i];
                return TarjetaProducto(
                  producto: producto,
                  alTocar: () => Navigator.pushNamed(
                    context,
                    AppRoutes.producto,
                    arguments: producto.id,
                  ),
                  alAgregar: () {
                    final resultado =
                        context.read<CarritoProvider>().agregar(producto);
                    mostrarResultadoAgregar(context, producto, resultado);
                  },
                );
              },
            ),
    );
  }
}
