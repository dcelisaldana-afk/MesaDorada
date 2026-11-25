import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../providers/carrito_provider.dart';

/// Ícono de carrito con contador, para la barra superior.
class IconoCarrito extends StatelessWidget {
  const IconoCarrito({super.key});

  @override
  Widget build(BuildContext context) {
    final cantidad =
        context.select<CarritoProvider, int>((c) => c.cantidadTotal);
    return IconButton(
      tooltip: 'Carrito',
      onPressed: () => Navigator.pushNamed(context, AppRoutes.carrito),
      icon: Badge(
        isLabelVisible: cantidad > 0,
        backgroundColor: AppColors.primario,
        label: Text('$cantidad'),
        child: const Icon(Icons.shopping_cart_outlined,
            color: AppColors.texto),
      ),
    );
  }
}
