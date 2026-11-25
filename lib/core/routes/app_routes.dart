import 'package:flutter/material.dart';

import '../../screens/carrito/carrito_screen.dart';
import '../../screens/cocina/formulario_producto_screen.dart';
import '../../screens/cocina/login_cocina_screen.dart';
import '../../screens/cocina/panel_cocina_screen.dart';
import '../../screens/cocina/widgets/guardia_cocina.dart';
import '../../screens/categoria/categoria_screen.dart';
import '../../screens/detalle_producto/detalle_producto_screen.dart';
import '../../screens/pedidos/confirmacion_pedido_screen.dart';
import '../../screens/pedidos/detalle_pedido_screen.dart';
import '../../screens/pedidos/mis_pedidos_screen.dart';
import '../../screens/principal/principal_screen.dart';
import '../../screens/splash/splash_screen.dart';

/// Clave global del navegador (permite abrir pantallas desde una
/// notificación).
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Nombres de rutas y construcción de pantallas en un solo lugar.
///
/// Flujo (documento de avances):
///   Splash → Principal (Inicio/Buscar/Pedidos/Más + Carrito)
///          → Categoría → Detalle → Carrito → Confirmación (turno)
///   Más → Acceso cocina (login) → Panel de cocina
///          (Pedidos · Inventario · Productos · Ajustes)
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  /// Pantalla principal con la barra inferior. Argumento opcional: índice
  /// de la pestaña (ver Pestana en principal_screen.dart).
  static const String menu = '/menu';
  static const String categoria = '/categoria'; // argumento: categoriaId
  static const String producto = '/producto'; // argumento: productoId
  static const String carrito = '/carrito';
  static const String confirmacion = '/confirmacion'; // argumento: pedidoId
  static const String misPedidos = '/pedidos';
  static const String detallePedido = '/pedido'; // argumento: pedidoId

  // Módulo de cocina (administrador)
  static const String loginCocina = '/cocina/login';
  static const String panelCocina = '/cocina';
  static const String formularioProducto =
      '/cocina/producto'; // argumento: productoId o null (nuevo)

  /// Rutas que solo puede abrir el personal de cocina con sesión iniciada.
  static const Set<String> _protegidas = {panelCocina, formularioProducto};

  static Route<dynamic> generar(RouteSettings ajustes) {
    final args = ajustes.arguments;
    Widget pantalla;

    switch (ajustes.name) {
      case splash:
        pantalla = const SplashScreen();
        break;
      case menu:
        pantalla = PrincipalScreen(
            pestanaInicial: args is int ? args : Pestana.inicio);
        break;
      case categoria:
        pantalla = CategoriaScreen(categoriaId: args as String);
        break;
      case producto:
        pantalla = DetalleProductoScreen(productoId: args as String);
        break;
      case carrito:
        pantalla = const CarritoScreen();
        break;
      case confirmacion:
        pantalla = ConfirmacionPedidoScreen(pedidoId: args as int);
        break;
      case misPedidos:
        pantalla = const MisPedidosScreen();
        break;
      case detallePedido:
        pantalla = DetallePedidoScreen(pedidoId: args as int);
        break;
      case loginCocina:
        pantalla = const LoginCocinaScreen();
        break;
      case panelCocina:
        pantalla = const PanelCocinaScreen();
        break;
      case formularioProducto:
        pantalla = FormularioProductoScreen(productoId: args as String?);
        break;
      default:
        pantalla = const PrincipalScreen();
    }

    if (_protegidas.contains(ajustes.name)) {
      pantalla = GuardiaCocina(child: pantalla);
    }

    return MaterialPageRoute(builder: (_) => pantalla, settings: ajustes);
  }
}
