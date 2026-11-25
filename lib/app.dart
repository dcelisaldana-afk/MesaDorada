import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/carrito_provider.dart';
import 'providers/catalogo_provider.dart';
import 'providers/pedidos_provider.dart';
import 'providers/sesion_provider.dart';
import 'services/notificacion_service.dart';

class LaMesaDoradaApp extends StatefulWidget {
  const LaMesaDoradaApp({super.key});

  @override
  State<LaMesaDoradaApp> createState() => _LaMesaDoradaAppState();
}

class _LaMesaDoradaAppState extends State<LaMesaDoradaApp> {
  @override
  void initState() {
    super.initState();
    final notificaciones = NotificacionService.instancia;

    // Tocar una notificación abre el seguimiento de ese pedido.
    notificaciones.alTocarNotificacion = _abrirPedido;

    // Si la app se abrió desde una notificación (estaba cerrada).
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = await notificaciones.pedidoQueAbrioLaApp();
      if (id != null) _abrirPedido(id);
    });
  }

  void _abrirPedido(int pedidoId) {
    navigatorKey.currentState
        ?.pushNamed(AppRoutes.detallePedido, arguments: pedidoId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatalogoProvider()..cargar()),
        // El carrito se sincroniza solo cada vez que cambia el catálogo
        // (por ejemplo, si la cocina agota un producto que está en él).
        ChangeNotifierProxyProvider<CatalogoProvider, CarritoProvider>(
          create: (_) => CarritoProvider(),
          update: (_, catalogo, carrito) =>
              carrito!..sincronizarStock(catalogo.producto),
        ),
        ChangeNotifierProvider(create: (_) => PedidosProvider()..cargar()),
        ChangeNotifierProvider(create: (_) => SesionProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.nombreRestaurante,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.claro,
        navigatorKey: navigatorKey,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generar,
      ),
    );
  }
}
