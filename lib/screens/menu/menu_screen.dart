import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/catalogo_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/estado_carga.dart';
import 'widgets/slider_destacados.dart';
import 'widgets/tarjeta_categoria.dart';

/// 2. Pantalla de Menú Principal (pestaña "Inicio" de la barra inferior).
/// El carrito se abre con el botón central de la barra de navegación.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalogo = context.watch<CatalogoProvider>();

    return Scaffold(
      appBar: const BarraSuperior(titulo: AppStrings.menu, mostrarAtras: false),
      body: EstadoCarga(
        cargando: catalogo.cargando && catalogo.categorias.isEmpty,
        error: catalogo.error,
        alReintentar: catalogo.cargar,
        child: RefreshIndicator(
          color: AppColors.primario,
          onRefresh: catalogo.recargarStock,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 8),
                  child: SliderDestacados(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Text(
                    AppStrings.categorias,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.texto,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.25,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final categoria = catalogo.categorias[i];
                      return TarjetaCategoria(
                        categoria: categoria,
                        alTocar: () => Navigator.pushNamed(
                          context,
                          AppRoutes.categoria,
                          arguments: categoria.id,
                        ),
                      );
                    },
                    childCount: catalogo.categorias.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
