import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formato_fecha.dart';
import '../../../core/utils/formato_moneda.dart';
import '../../../data/models/pedido.dart';

/// Color que identifica cada estado en el panel de cocina.
Color colorEstado(EstadoPedido estado) {
  switch (estado) {
    case EstadoPedido.recibido:
      return const Color(0xFFE08A00); // nuevo
    case EstadoPedido.enPreparacion:
      return const Color(0xFF1E6FB8);
    case EstadoPedido.listo:
      return AppColors.exito;
    case EstadoPedido.entregado:
      return AppColors.textoSecundario;
  }
}

/// Tarjeta de un pedido en el panel de cocina: turno, tipo, productos y
/// botón para pasar al siguiente estado.
class TarjetaPedidoCocina extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback? alAvanzar;

  const TarjetaPedidoCocina({
    super.key,
    required this.pedido,
    required this.alAvanzar,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorEstado(pedido.estado);
    final accion = pedido.estado.accionCocina;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TURNO',
                      style: TextStyle(
                          fontSize: 10.5,
                          letterSpacing: 1,
                          color: AppColors.textoSecundario,
                          fontWeight: FontWeight.w700)),
                  Text(
                    pedido.turno,
                    style: const TextStyle(
                      fontSize: 30,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: AppColors.texto,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _Etiqueta(
                          texto: pedido.estado.titulo,
                          color: color,
                          icono: pedido.estado.icono,
                        ),
                        _Etiqueta(
                          texto: pedido.paraLlevar ? 'Para llevar' : 'Comer aquí',
                          color: AppColors.texto,
                          icono: pedido.paraLlevar
                              ? Icons.shopping_bag_outlined
                              : Icons.restaurant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${formatoHora(pedido.fecha)} · ${haceCuanto(pedido.fecha)}',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textoSecundario),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.borde),
          ),
          for (final item in pedido.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.fondo,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${item.cantidad}×',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.nombre,
                      style: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Total ${formatoPesos(pedido.total)}',
                style: const TextStyle(
                    color: AppColors.textoSecundario, fontSize: 13),
              ),
              const Spacer(),
              if (accion != null && alAvanzar != null)
                FilledButton.icon(
                  onPressed: alAvanzar,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        colorEstado(pedido.estado.siguiente!),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(pedido.estado.siguiente!.icono, size: 18),
                  label: Text(accion),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final String texto;
  final Color color;
  final IconData icono;

  const _Etiqueta({
    required this.texto,
    required this.color,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: color),
          const SizedBox(width: 4),
          Text(texto,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
