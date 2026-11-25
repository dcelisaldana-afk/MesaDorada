import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/sesion_provider.dart';
import '../login_cocina_screen.dart';

/// Protege las pantallas de cocina: si no hay sesión iniciada (o se cerró
/// por inactividad) muestra el inicio de sesión en su lugar. Además
/// registra cada toque como actividad para el cierre automático.
class GuardiaCocina extends StatelessWidget {
  final Widget child;

  const GuardiaCocina({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();
    if (!sesion.autenticado) return const LoginCocinaScreen();

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => sesion.registrarActividad(),
      child: child,
    );
  }
}
