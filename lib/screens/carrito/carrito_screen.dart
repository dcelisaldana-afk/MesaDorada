import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../data/repositories/pedido_repository.dart';
import '../../providers/carrito_provider.dart';
import '../../providers/catalogo_provider.dart';
import '../../providers/pedidos_provider.dart';
import '../../services/notificacion_service.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/boton_carrito.dart';
import '../../widgets/estado_carga.dart';
import '../../widgets/mensajes.dart';
import 'widgets/campo_codigo_promocional.dart';
import 'widgets/item_carrito_tile.dart';
import 'widgets/resumen_orden.dart';
import 'widgets/selector_tipo_entrega.dart';

/// 5. Pantalla de Carrito.
class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  Future<void> _realizarPedido(BuildContext context) async {
    final carrito = context.read<CarritoProvider>();
    final catalogo = context.read<CatalogoProvider>();
    final pedidos = context.read<PedidosProvider>();
    final navegador = Navigator.of(context);

    // Pide permiso de notificaciones (solo muestra el diálogo la 1ª vez).
    await NotificacionService.instancia.solicitarPermiso();

    try {
      final pedido = await pedidos.realizarPedido(carrito);
      carrito.vaciar();
      await catalogo.recargarStock();
      navegador.pushNamedAndRemoveUntil(
        AppRoutes.confirmacion,
        (ruta) => ruta.settings.name == AppRoutes.menu,
        arguments: pedido.id,
      );
    } on StockInsuficienteException catch (e) {
      await catalogo.recargarStock();
      carrito.sincronizarStock(catalogo.producto);
      if (context.mounted) mostrarMensaje(context, e.toString());
    } catch (e) {
      if (context.mounted) {
        mostrarMensaje(context, 'No se pudo realizar el pedido: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();
    final enviando = context.select<PedidosProvider, bool>((p) => p.enviando);
    final tecladoAbierto = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: const BarraSuperior(titulo: AppStrings.carrito),
      body: carrito.estaVacio
          ? MensajeVacio(
              icono: Icons.shopping_cart_outlined,
              titulo: 'Tu carrito está vacío',
              subtitulo: 'Agrega platos desde el menú para hacer tu pedido.',
              accion: TextButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.menu, (r) => false),
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Ver el menú'),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    children: [
                      for (final item in carrito.items) ...[
                        ItemCarritoTile(
                          item: item,
                          alAumentar: () =>
                              carrito.incrementar(item.producto.id),
                          alDisminuir: () =>
                              carrito.disminuir(item.producto.id),
                          alEliminar: () =>
                              carrito.eliminar(item.producto.id),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 4),
                      const SelectorTipoEntrega(),
                      const SizedBox(height: 12),
                      const CampoCodigoPromocional(),
                    ],
                  ),
                ),
                if (!tecladoAbierto)
                  ResumenOrden(
                    subtotal: carrito.subtotal,
                    descuento: carrito.descuento,
                    total: carrito.total,
                    boton: BotonPrincipal(
                      icono: Icons.check,
                      texto: AppStrings.realizarPedido,
                      cargando: enviando,
                      alPresionar: () => _realizarPedido(context),
                    ),
                  ),
              ],
            ),
    );
  }
}
