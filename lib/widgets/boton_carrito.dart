import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/routes/app_routes.dart';
import '../providers/carrito_provider.dart';

/// Botón fijo inferior "Carrito (N items)" presente en Menú, Categoría y
/// Detalle. Siempre lleva a la Pantalla de Carrito.
class BotonCarrito extends StatelessWidget {
  const BotonCarrito({super.key});

  @override
  Widget build(BuildContext context) {
    final cantidad = context.select<CarritoProvider, int>((c) => c.cantidadTotal);
    return BarraInferior(
      child: BotonPrincipal(
        icono: Icons.shopping_cart_outlined,
        texto: '${AppStrings.carrito} ($cantidad ${cantidad == 1 ? 'item' : 'items'})',
        alPresionar: () => Navigator.pushNamed(context, AppRoutes.carrito),
      ),
    );
  }
}

/// Contenedor inferior con fondo y margen seguro (para botones fijos).
class BarraInferior extends StatelessWidget {
  final Widget child;

  const BarraInferior({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.fondo,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: child,
        ),
      ),
    );
  }
}

/// Botón ancho redondeado color terracota (estilo del prototipo).
class BotonPrincipal extends StatelessWidget {
  final IconData? icono;
  final String texto;
  final VoidCallback? alPresionar;
  final bool cargando;

  const BotonPrincipal({
    super.key,
    this.icono,
    required this.texto,
    required this.alPresionar,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: cargando ? null : alPresionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primario,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.agotado,
          disabledForegroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0x55C95A3C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: cargando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icono != null) ...[
                    Icon(icono, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      texto,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
