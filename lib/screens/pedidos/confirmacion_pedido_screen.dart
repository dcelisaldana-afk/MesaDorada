import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formato_moneda.dart';
import '../../providers/pedidos_provider.dart';
import '../../widgets/boton_carrito.dart';

/// Confirmación de compra (último paso del flujo del prototipo).
class ConfirmacionPedidoScreen extends StatelessWidget {
  final int pedidoId;

  const ConfirmacionPedidoScreen({super.key, required this.pedidoId});

  void _volverAlMenu(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.menu, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final pedido = context.watch<PedidosProvider>().pedido(pedidoId);

    // Al presionar "atrás" se vuelve al Menú (queda debajo en la pila).
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.4, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, escala, child) =>
                    Transform.scale(scale: escala, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.primario,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x55C95A3C),
                          blurRadius: 24,
                          offset: Offset(0, 10)),
                    ],
                  ),
                  child:
                      const Icon(Icons.check, size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                '¡Pedido realizado!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.texto,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pedido == null
                    ? 'Tu pedido fue recibido.'
                    : 'Total ${formatoPesos(pedido.total)} · ${pedido.paraLlevar ? AppStrings.paraLlevar : AppStrings.comerAqui}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15, color: AppColors.textoSecundario),
              ),
              if (pedido != null) ...[
                const SizedBox(height: 18),
                const Text(
                  'Tu número de turno',
                  style: TextStyle(fontSize: 14, color: AppColors.texto),
                ),
                Text(
                  pedido.turno,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primario,
                    letterSpacing: 4,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.superficie,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_active_outlined,
                        color: AppColors.primario, size: 20),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Te avisaremos con una notificación cuando esté listo para recoger en la barra.',
                        style: TextStyle(fontSize: 13, color: AppColors.texto),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              BotonPrincipal(
                icono: Icons.receipt_long,
                texto: 'Seguir mi pedido',
                alPresionar: () => Navigator.pushNamed(
                  context,
                  AppRoutes.detallePedido,
                  arguments: pedidoId,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _volverAlMenu(context),
                child: const Text(
                  'Volver al menú',
                  style: TextStyle(
                    color: AppColors.primario,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
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
