import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/catalogo_provider.dart';
import '../../providers/pedidos_provider.dart';
import '../../providers/sesion_provider.dart';
import 'tabs/ajustes_cocina_tab.dart';
import 'tabs/inventario_tab.dart';
import 'tabs/pedidos_cocina_tab.dart';
import 'tabs/productos_tab.dart';

/// Apartado exclusivo del personal de cocina (RF-08 a RF-10).
///
/// Cuatro pestañas: Pedidos (atender pedidos), Inventario (stock y
/// disponibilidad), Productos (crear/editar/desactivar) y Ajustes.
class PanelCocinaScreen extends StatefulWidget {
  const PanelCocinaScreen({super.key});

  @override
  State<PanelCocinaScreen> createState() => _PanelCocinaScreenState();
}

class _PanelCocinaScreenState extends State<PanelCocinaScreen> {
  int _actual = 0;

  static const List<String> _titulos = [
    'Pedidos',
    'Inventario',
    'Productos',
    'Ajustes',
  ];

  static const List<Widget> _pestanas = [
    PedidosCocinaTab(),
    InventarioTab(),
    ProductosTab(),
    AjustesCocinaTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<SesionProvider>().usuario;
    final nuevos =
        context.select<PedidosProvider, int>((p) => p.cantidadNuevos);
    final stockBajo = context
        .select<CatalogoProvider, int>((c) => c.productosStockBajo.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cocina · ${_titulos[_actual]}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
            ),
            if (usuario != null)
              Text(
                usuario.nombre,
                style: const TextStyle(fontSize: 12.5, color: Color(0xDDFFFFFF)),
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => cerrarSesionCocina(context),
          ),
        ],
      ),
      body: IndexedStack(index: _actual, children: _pestanas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _actual,
        onDestinationSelected: (i) => setState(() => _actual = i),
        backgroundColor: AppColors.superficie,
        indicatorColor: const Color(0x33C95A3C),
        destinations: [
          NavigationDestination(
            icon: Badge(
              isLabelVisible: nuevos > 0,
              label: Text('$nuevos'),
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: const Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: stockBajo > 0,
              backgroundColor: const Color(0xFFE08A00),
              label: Text('$stockBajo'),
              child: const Icon(Icons.inventory_2_outlined),
            ),
            selectedIcon: const Icon(Icons.inventory_2),
            label: 'Inventario',
          ),
          const NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Productos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

/// Sale del panel (vuelve a la parte de clientes) y cierra la sesión.
Future<void> cerrarSesionCocina(BuildContext context) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Quieres salir del panel de cocina?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.primario),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );
  if (confirmar != true || !context.mounted) return;
  final sesion = context.read<SesionProvider>();
  Navigator.of(context).popUntil((ruta) =>
      ruta.isFirst || !(ruta.settings.name ?? '').startsWith('/cocina'));
  sesion.cerrarSesion();
}
