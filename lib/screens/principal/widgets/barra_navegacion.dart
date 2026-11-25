import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/carrito_provider.dart';
import '../../../providers/pedidos_provider.dart';
import '../principal_screen.dart';

/// Barra de navegación inferior estilo TikTok: 4 pestañas con ícono y
/// texto, y un botón central destacado (el carrito) con el contador.
class BarraNavegacion extends StatelessWidget {
  final int actual;
  final ValueChanged<int> alCambiar;
  final VoidCallback alTocarCarrito;

  const BarraNavegacion({
    super.key,
    required this.actual,
    required this.alCambiar,
    required this.alTocarCarrito,
  });

  @override
  Widget build(BuildContext context) {
    final enCarrito =
        context.select<CarritoProvider, int>((c) => c.cantidadTotal);
    final pedidosActivos =
        context.select<PedidosProvider, bool>((p) => p.hayActivos);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.superficie,
        border: Border(top: BorderSide(color: AppColors.borde)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              _Pestana(
                icono: Icons.home_outlined,
                iconoActivo: Icons.home_rounded,
                texto: AppStrings.inicio,
                activa: actual == Pestana.inicio,
                alTocar: () => alCambiar(Pestana.inicio),
              ),
              _Pestana(
                icono: Icons.search_rounded,
                iconoActivo: Icons.manage_search_rounded,
                texto: AppStrings.buscar,
                activa: actual == Pestana.buscar,
                alTocar: () => alCambiar(Pestana.buscar),
              ),
              Expanded(
                child: Center(
                  child: _BotonCentral(
                    cantidad: enCarrito,
                    alTocar: alTocarCarrito,
                  ),
                ),
              ),
              _Pestana(
                icono: Icons.receipt_long_outlined,
                iconoActivo: Icons.receipt_long,
                texto: AppStrings.pedidos,
                activa: actual == Pestana.pedidos,
                punto: pedidosActivos,
                alTocar: () => alCambiar(Pestana.pedidos),
              ),
              _Pestana(
                icono: Icons.person_outline_rounded,
                iconoActivo: Icons.person_rounded,
                texto: AppStrings.mas,
                activa: actual == Pestana.mas,
                alTocar: () => alCambiar(Pestana.mas),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pestana extends StatelessWidget {
  final IconData icono;
  final IconData iconoActivo;
  final String texto;
  final bool activa;
  final bool punto;
  final VoidCallback alTocar;

  const _Pestana({
    required this.icono,
    required this.iconoActivo,
    required this.texto,
    required this.activa,
    required this.alTocar,
    this.punto = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = activa ? AppColors.texto : AppColors.textoSecundario;
    return Expanded(
      child: InkResponse(
        onTap: alTocar,
        radius: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(activa ? iconoActivo : icono, size: 26, color: color),
                if (punto)
                  Positioned(
                    right: -2,
                    top: -1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.primario,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              texto,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: activa ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón central como el "+" de TikTok: tres capas desplazadas (dorado,
/// oscuro y terracota) con el ícono del carrito y el número de productos.
class _BotonCentral extends StatelessWidget {
  final int cantidad;
  final VoidCallback alTocar;

  const _BotonCentral({required this.cantidad, required this.alTocar});

  @override
  Widget build(BuildContext context) {
    const ancho = 50.0;
    const alto = 34.0;
    final radio = BorderRadius.circular(10);

    return GestureDetector(
      onTap: alTocar,
      child: SizedBox(
        width: ancho + 8,
        height: alto + 8,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(-3, 0),
              child: Container(
                width: ancho,
                height: alto,
                decoration: BoxDecoration(
                    color: AppColors.estrella, borderRadius: radio),
              ),
            ),
            Transform.translate(
              offset: const Offset(3, 0),
              child: Container(
                width: ancho,
                height: alto,
                decoration:
                    BoxDecoration(color: AppColors.texto, borderRadius: radio),
              ),
            ),
            Container(
              width: ancho - 6,
              height: alto,
              decoration:
                  BoxDecoration(color: AppColors.primario, borderRadius: radio),
              child: const Icon(Icons.shopping_cart_outlined,
                  color: Colors.white, size: 22),
            ),
            if (cantidad > 0)
              Positioned(
                right: -4,
                top: -6,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.texto,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    '$cantidad',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
