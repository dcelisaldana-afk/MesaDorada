import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/pedido.dart';

/// Línea de tiempo vertical con los 4 estados del pedido.
class LineaTiempoPedido extends StatelessWidget {
  final EstadoPedido estadoActual;

  const LineaTiempoPedido({super.key, required this.estadoActual});

  @override
  Widget build(BuildContext context) {
    final estados = EstadoPedido.values;
    return Column(
      children: [
        for (var i = 0; i < estados.length; i++)
          _Paso(
            estado: estados[i],
            completado: estados[i].index <= estadoActual.index,
            actual: estados[i] == estadoActual,
            esUltimo: i == estados.length - 1,
          ),
      ],
    );
  }
}

class _Paso extends StatelessWidget {
  final EstadoPedido estado;
  final bool completado;
  final bool actual;
  final bool esUltimo;

  const _Paso({
    required this.estado,
    required this.completado,
    required this.actual,
    required this.esUltimo,
  });

  @override
  Widget build(BuildContext context) {
    final color = completado ? AppColors.primario : AppColors.borde;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: completado ? AppColors.primario : AppColors.superficie,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    estado.icono,
                    size: 18,
                    color: completado ? Colors.white : AppColors.agotado,
                  ),
                ),
                if (!esUltimo)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: color,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6, bottom: esUltimo ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    estado.titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: actual ? FontWeight.w800 : FontWeight.w600,
                      color: completado ? AppColors.texto : AppColors.agotado,
                    ),
                  ),
                  if (actual) ...[
                    const SizedBox(height: 2),
                    Text(
                      estado.mensaje,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
