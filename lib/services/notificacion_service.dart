import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/constants/app_colors.dart';
import '../data/models/pedido.dart';

/// Notificaciones push del estado del pedido.
///
/// Se envían en dos momentos:
///   1. Cuando el cliente realiza el pedido ("Pedido recibido").
///   2. Cada vez que la cocina cambia el estado desde su panel
///      (en preparación, listo para recoger, entregado).
/// El sistema operativo las muestra aunque la app esté en segundo plano.
class NotificacionService {
  NotificacionService._();
  static final NotificacionService instancia = NotificacionService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _inicializado = false;
  Future<void>? _inicializando;

  /// Se llama cuando el usuario toca una notificación (payload = id pedido).
  void Function(int pedidoId)? alTocarNotificacion;

  static const AndroidNotificationChannel _canal = AndroidNotificationChannel(
    'estado_pedidos',
    'Estado de pedidos',
    description: 'Avisos sobre el estado de tus pedidos',
    importance: Importance.high,
  );

  /// Puede llamarse varias veces: solo inicializa una vez.
  Future<void> inicializar() => _inicializando ??= _inicializar();

  /// Espera a que termine la inicialización (sin lanzar errores).
  Future<bool> _listo() async {
    try {
      await inicializar();
    } catch (_) {}
    return _inicializado;
  }

  Future<void> _inicializar() async {
    if (_inicializado || kIsWeb) return;

    const ajustes = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      ajustes,
      onDidReceiveNotificationResponse: (respuesta) =>
          _manejarPayload(respuesta.payload),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_canal);

    _inicializado = true;
  }

  /// Si la app se abrió tocando una notificación, devuelve el id del pedido.
  Future<int?> pedidoQueAbrioLaApp() async {
    if (!await _listo()) return null;
    final detalles = await _plugin.getNotificationAppLaunchDetails();
    if (detalles?.didNotificationLaunchApp ?? false) {
      return _idDesdePayload(detalles!.notificationResponse?.payload);
    }
    return null;
  }

  /// Pide permiso para mostrar notificaciones (Android 13+ e iOS).
  Future<bool> solicitarPermiso() async {
    if (!await _listo()) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
              alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  /// Muestra la notificación del estado actual del pedido.
  Future<void> notificarEstado(Pedido pedido) async {
    if (!await _listo() || pedido.id == null) return;
    final estado = pedido.estado;
    await _plugin.show(
      _idNotificacion(pedido.id!, estado),
      '${pedido.codigo} · ${estado.titulo}',
      estado.mensaje,
      _detalles(estado.mensaje),
      payload: '${pedido.id}',
    );
  }

  /// Notificación de prueba desde la pestaña Más.
  Future<void> enviarPrueba() async {
    if (!await _listo()) return;
    await _plugin.show(
      0,
      'La Mesa Dorada',
      'Las notificaciones están activas. Te avisaremos el estado de tus pedidos.',
      _detalles('Las notificaciones están activas.'),
    );
  }

  NotificationDetails _detalles(String cuerpo) => NotificationDetails(
        android: AndroidNotificationDetails(
          _canal.id,
          _canal.name,
          channelDescription: _canal.description,
          importance: Importance.high,
          priority: Priority.high,
          color: AppColors.primario,
          styleInformation: BigTextStyleInformation(cuerpo),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  int _idNotificacion(int pedidoId, EstadoPedido estado) =>
      pedidoId * 10 + estado.index + 1;

  int? _idDesdePayload(String? payload) =>
      payload == null ? null : int.tryParse(payload);

  void _manejarPayload(String? payload) {
    final id = _idDesdePayload(payload);
    if (id != null) alTocarNotificacion?.call(id);
  }
}
