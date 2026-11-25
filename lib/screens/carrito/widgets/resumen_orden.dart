import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formato_moneda.dart';

/// Panel inferior con Subtotal, descuento, Total y el botón de pedido.
class ResumenOrden extends StatelessWidget {
  final int subtotal;
  final int descuento;
  final int total;
  final Widget boton;

  const ResumenOrden({
    super.key,
    required this.subtotal,
    required this.descuento,
    required this.total,
    required this.boton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Fila(AppStrings.subtotal, formatoPesos(subtotal)),
              if (descuento > 0)
                _Fila('Descuento', '-${formatoPesos(descuento)}',
                    colorValor: AppColors.exito),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: AppColors.borde, height: 1),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      AppStrings.totalOrden,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.texto,
                      ),
                    ),
                  ),
                  Text(
                    formatoPesos(total),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              boton,
            ],
          ),
        ),
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final Color? colorValor;

  const _Fila(this.etiqueta, this.valor, {this.colorValor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                  color: AppColors.textoSecundario, fontSize: 14),
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              color: colorValor ?? AppColors.texto,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
