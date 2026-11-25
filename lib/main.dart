import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/notificacion_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // La app está diseñada para uso vertical en el celular.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Se dibuja la app de inmediato: nada se espera antes de runApp para que
  // nunca quede la pantalla en negro.
  runApp(const LaMesaDoradaApp());

  // Las notificaciones se preparan en segundo plano, después del primer
  // cuadro. Si fallan, la app sigue funcionando.
  NotificacionService.instancia
      .inicializar()
      .timeout(const Duration(seconds: 10))
      .catchError((Object e) => debugPrint('Notificaciones no disponibles: $e'));
}
