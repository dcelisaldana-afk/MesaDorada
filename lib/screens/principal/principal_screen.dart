import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../buscar/buscar_screen.dart';
import '../mas/mas_screen.dart';
import '../menu/menu_screen.dart';
import '../pedidos/mis_pedidos_screen.dart';
import 'widgets/barra_navegacion.dart';

/// Pantalla contenedora con la barra de navegación inferior (estilo TikTok):
///   Inicio · Buscar · [Carrito] · Pedidos · Más
///
/// Cada pestaña conserva su estado (scroll, búsqueda) al cambiar de una a otra.
class PrincipalScreen extends StatefulWidget {
  /// Índice de la pestaña inicial (ver [Pestana]).
  final int pestanaInicial;

  const PrincipalScreen({super.key, this.pestanaInicial = Pestana.inicio});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

/// Índices de las pestañas (el carrito no es pestaña: se abre encima).
class Pestana {
  Pestana._();
  static const int inicio = 0;
  static const int buscar = 1;
  static const int pedidos = 2;
  static const int mas = 3;
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  late int _actual = widget.pestanaInicial;

  static const List<Widget> _pestanas = [
    MenuScreen(),
    BuscarScreen(),
    MisPedidosScreen(comoPestana: true),
    MasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _actual, children: _pestanas),
      bottomNavigationBar: BarraNavegacion(
        actual: _actual,
        alCambiar: (i) => setState(() => _actual = i),
        alTocarCarrito: () => Navigator.pushNamed(context, AppRoutes.carrito),
      ),
    );
  }
}
