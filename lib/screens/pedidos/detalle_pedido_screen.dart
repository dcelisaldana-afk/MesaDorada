import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formato_fecha.dart';
import '../../core/utils/formato_moneda.dart';
import '../../data/models/pedido.dart';
import '../../providers/pedidos_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/estado_carga.dart';
import '../../widgets/imagen_plato.dart';
import 'widgets/linea_tiempo_pedido.dart';

/// Seguimiento de un pedido: estado actual, línea de tiempo y resumen.
class DetallePedidoScreen extends StatelessWidget {
  final int pedidoId;

  const DetallePedidoScreen({super.key, required this.pedidoId});

  @override
  Widget build(BuildContext context) {
    final proveedor = context.watch<PedidosProvider>();
    final pedido = proveedor.pedido(pedidoId);

    if (pedido == null) {
      return const Scaffold(
        appBar: BarraSuperior(titulo: 'Pedido'),
        body: MensajeVacio(
            icono: Icons.search_off, titulo: 'Pedido no encontrado'),
      );
    }

    final estado = pedido.estado;

    return Scaffold(
      appBar: BarraSuperior(titulo: pedido.codigo),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          // Tarjeta de estado actual
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primario,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(estado.icono, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        estado.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        estado == EstadoPedido.listo
                            ? 'Recógelo en la barra · ${pedido.codigo}'
                            : estado.activo
                                ? 'Te avisaremos cuando la cocina lo tenga listo'
                                : estado.mensaje,
                        style: const TextStyle(
                            color: Color(0xE6FFFFFF), fontSize: 13.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _Seccion(
            titulo: 'Seguimiento',
            child: LineaTiempoPedido(estadoActual: estado),
          ),
          const SizedBox(height: 16),
          _Seccion(
            titulo: 'Productos',
            child: Column(
              children: [
                for (final item in pedido.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 46,
                            height: 46,
                            child: ImagenPlato(
                              rutas: [item.imagen],
                              url: item.imagenUrl(ancho: 150),
                              categoriaId: '',
                              tamanoIcono: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${item.cantidad}× ${item.nombre}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.texto),
                          ),
                        ),
                        Text(
                          formatoPesos(item.subtotal),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.texto),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Seccion(
            titulo: 'Resumen',
            child: Column(
              children: [
                _Fila('Fecha', formatoFecha(pedido.fecha)),
                _Fila('Tipo',
                    pedido.paraLlevar ? AppStrings.paraLlevar : AppStrings.comerAqui),
                _Fila(AppStrings.subtotal, formatoPesos(pedido.subtotal)),
                if (pedido.descuento > 0)
                  _Fila(
                    'Descuento${pedido.codigoPromocional != null ? ' (${pedido.codigoPromocional})' : ''}',
                    '-${formatoPesos(pedido.descuento)}',
                  ),
                const Divider(color: AppColors.borde),
                _Fila(AppStrings.totalOrden, formatoPesos(pedido.total),
                    destacado: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final Widget child;

  const _Seccion({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool destacado;

  const _Fila(this.etiqueta, this.valor, {this.destacado = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: TextStyle(
                color: destacado ? AppColors.texto : AppColors.textoSecundario,
                fontWeight: destacado ? FontWeight.w800 : FontWeight.w400,
                fontSize: destacado ? 16 : 14,
              ),
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              color: destacado ? AppColors.primario : AppColors.texto,
              fontWeight: destacado ? FontWeight.w800 : FontWeight.w600,
              fontSize: destacado ? 17 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
