import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../providers/pedidos_provider.dart';
import '../../../widgets/estado_carga.dart';
import '../widgets/tarjeta_pedido_cocina.dart';

/// Pedidos entrantes en orden de llegada (RF-10). La cocina los avanza:
/// recibido → en preparación → listo para recoger → entregado.
/// Cada cambio notifica al cliente.
class PedidosCocinaTab extends StatefulWidget {
  const PedidosCocinaTab({super.key});

  @override
  State<PedidosCocinaTab> createState() => _PedidosCocinaTabState();
}

class _PedidosCocinaTabState extends State<PedidosCocinaTab> {
  bool _verEntregados = false;
  Timer? _reloj;

  @override
  void initState() {
    super.initState();
    // Refresca el "hace X min" de cada pedido.
    _reloj = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proveedor = context.watch<PedidosProvider>();
    final enCurso = proveedor.pedidosCocina;
    final entregados = proveedor.pedidosEntregados;
    final lista = _verEntregados ? entregados : enCurso;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: SegmentedButton<bool>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: AppColors.primario,
              selectedForegroundColor: Colors.white,
            ),
            segments: [
              ButtonSegment(
                value: false,
                icon: const Icon(Icons.local_fire_department_outlined),
                label: Text('En curso (${enCurso.length})'),
              ),
              ButtonSegment(
                value: true,
                icon: const Icon(Icons.task_alt),
                label: Text('Entregados (${entregados.length})'),
              ),
            ],
            selected: {_verEntregados},
            onSelectionChanged: (s) => setState(() => _verEntregados = s.first),
          ),
        ),
        Expanded(
          child: lista.isEmpty
              ? MensajeVacio(
                  icono: _verEntregados
                      ? Icons.inbox_outlined
                      : Icons.restaurant_outlined,
                  titulo: _verEntregados
                      ? 'Aún no hay pedidos entregados'
                      : 'No hay pedidos pendientes',
                  subtitulo: _verEntregados
                      ? null
                      : 'Los pedidos nuevos de los clientes aparecerán aquí al instante.',
                )
              : RefreshIndicator(
                  color: AppColors.primario,
                  onRefresh: proveedor.cargar,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: lista.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final pedido = lista[i];
                      return TarjetaPedidoCocina(
                        pedido: pedido,
                        alAvanzar: pedido.estado.siguiente == null
                            ? null
                            : () => proveedor.avanzarEstado(pedido.id!),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
