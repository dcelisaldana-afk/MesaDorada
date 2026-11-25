import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formato_moneda.dart';
import '../../../providers/catalogo_provider.dart';
import '../../../widgets/imagen_plato.dart';
import '../../../widgets/mensajes.dart';

/// Gestión del menú: crear, editar y mostrar/ocultar productos.
class ProductosTab extends StatelessWidget {
  const ProductosTab({super.key});

  @override
  Widget build(BuildContext context) {
    final catalogo = context.watch<CatalogoProvider>();
    final categorias = catalogo.categorias;
    final productos = catalogo.productosAdmin;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.formularioProducto),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          for (final c in categorias) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
              child: Text(
                c.nombre,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            for (final p in productos.where((p) => p.categoriaId == c.id))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: p.activo
                      ? AppColors.superficie
                      : AppColors.agotadoFondo,
                  borderRadius: BorderRadius.circular(14),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    contentPadding:
                        const EdgeInsets.only(left: 10, right: 4),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 46,
                        height: 46,
                        child: ImagenPlato(
                          rutas: [p.imagen],
                          url: p.imagenUrl(ancho: 150),
                          categoriaId: p.categoriaId,
                          enGris: !p.activo,
                          tamanoIcono: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      p.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: p.activo
                            ? AppColors.texto
                            : AppColors.textoSecundario,
                      ),
                    ),
                    subtitle: Text(
                      '${formatoPesos(p.precio)} · ${p.activo ? 'En el menú' : 'Oculto'}',
                      style: const TextStyle(fontSize: 12.5),
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.formularioProducto,
                      arguments: p.id,
                    ),
                    trailing: Switch(
                      value: p.activo,
                      activeTrackColor: AppColors.primario,
                      onChanged: (v) async {
                        await catalogo.cambiarActivo(p.id, v);
                        if (context.mounted) {
                          mostrarMensaje(
                              context,
                              v
                                  ? '${p.nombre} vuelve al menú'
                                  : '${p.nombre} se ocultó del menú');
                        }
                      },
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
