import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formato_fecha.dart';
import '../../core/utils/formato_moneda.dart';
import '../../data/models/pedido.dart';
import '../../providers/pedidos_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/estado_carga.dart';
import 'widgets/chip_estado.dart';

/// Historial de pedidos realizados (diseño de interfaz de pedidos, S7-S8).
class MisPedidosScreen extends StatelessWidget {
  /// true cuando se muestra como pestaña de la barra inferior.
  final bool comoPestana;

  const MisPedidosScreen({super.key, this.comoPestana = false});

  @override
  Widget build(BuildContext context) {
    final pedidos = context.watch<PedidosProvider>().pedidos;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: AppStrings.misPedidos,
        mostrarAtras: !comoPestana,
      ),
      body: pedidos.isEmpty
          ? MensajeVacio(
              icono: Icons.receipt_long_outlined,
              titulo: 'Aún no tienes pedidos',
              subtitulo: 'Cuando realices un pedido lo verás aquí.',
              accion: TextButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.menu, (r) => false),
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Ir al menú'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: pedidos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _TarjetaPedido(pedido: pedidos[i]),
            ),
    );
  }
}

class _TarjetaPedido extends StatelessWidget {
  final Pedido pedido;

  const _TarjetaPedido({required this.pedido});

  @override
  Widget build(BuildContext context) {
    final n = pedido.cantidadProductos;
    return Material(
      color: AppColors.superficie,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: const Color(0x22000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, AppRoutes.detallePedido,
            arguments: pedido.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pedido.codigo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.texto,
                      ),
                    ),
                  ),
                  ChipEstado(estado: pedido.estado),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                formatoFecha(pedido.fecha),
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textoSecundario),
              ),
              const SizedBox(height: 10),
              Text(
                pedido.items.map((i) => '${i.cantidad}× ${i.nombre}').join(', '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13.5, color: AppColors.texto),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '$n ${n == 1 ? 'producto' : 'productos'}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textoSecundario),
                  ),
                  const Spacer(),
                  Text(
                    formatoPesos(pedido.total),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primario,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
