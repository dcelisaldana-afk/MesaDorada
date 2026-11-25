import 'package:flutter/foundation.dart';

import '../data/models/pedido.dart';
import '../data/repositories/pedido_repository.dart';
import '../services/notificacion_service.dart';
import 'carrito_provider.dart';

/// Pedidos: los realiza el cliente y los atiende la cocina.
///
/// El cliente crea el pedido (estado "recibido"). La cocina lo ve en su
/// panel y lo avanza: en preparación → listo para recoger → entregado.
/// Cada cambio se guarda en la base de datos, se avisa a todas las
/// pantallas (`notifyListeners`) y se envía una notificación al cliente.
class PedidosProvider extends ChangeNotifier {
  final PedidoRepository _repo;
  final NotificacionService _notificaciones;

  PedidosProvider({
    PedidoRepository? repo,
    NotificacionService? notificaciones,
  })  : _repo = repo ?? PedidoRepository(),
        _notificaciones = notificaciones ?? NotificacionService.instancia;

  List<Pedido> _pedidos = [];
  bool _enviando = false;

  /// Historial del cliente, del más reciente al más antiguo.
  List<Pedido> get pedidos => List.unmodifiable(_pedidos);

  /// Hay pedidos que todavía no se han entregado.
  bool get hayActivos => _pedidos.any((p) => p.estado.activo);
  bool get enviando => _enviando;

  /// Pedidos pendientes para la cocina, en orden de llegada.
  List<Pedido> get pedidosCocina =>
      _pedidos.where((p) => p.estado.activo).toList()
        ..sort((a, b) => a.fecha.compareTo(b.fecha));

  /// Pedidos ya entregados (más recientes primero).
  List<Pedido> get pedidosEntregados =>
      _pedidos.where((p) => !p.estado.activo).toList();

  /// Pedidos nuevos que la cocina aún no ha empezado.
  int get cantidadNuevos =>
      _pedidos.where((p) => p.estado == EstadoPedido.recibido).length;

  Pedido? pedido(int id) {
    for (final p in _pedidos) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> cargar() async {
    try {
      _pedidos = await _repo.obtenerTodos();
      notifyListeners();
    } catch (e) {
      debugPrint('No se pudo cargar el historial de pedidos: $e');
    }
  }

  /// Convierte el carrito en un pedido, lo guarda en la base de datos y
  /// descuenta el stock en una sola transacción.
  Future<Pedido> realizarPedido(CarritoProvider carrito) async {
    if (carrito.estaVacio) {
      throw StateError('El carrito está vacío');
    }
    _enviando = true;
    notifyListeners();
    try {
      final nuevo = Pedido(
        fecha: DateTime.now(),
        subtotal: carrito.subtotal,
        descuento: carrito.descuento,
        envio: 0, // autoservicio
        total: carrito.total,
        codigoPromocional: carrito.codigoAplicado?.codigo,
        tipoEntrega: carrito.tipoEntrega,
        items: carrito.items
            .map((i) => PedidoItem(
                  productoId: i.producto.id,
                  nombre: i.producto.nombre,
                  precioUnitario: i.producto.precio,
                  cantidad: i.cantidad,
                ))
            .toList(),
      );

      final guardado = await _repo.guardar(nuevo);
      _pedidos = [guardado, ..._pedidos];

      // La notificación no debe impedir que el pedido se complete.
      try {
        await _notificaciones.notificarEstado(guardado);
      } catch (e) {
        debugPrint('Error al notificar: $e');
      }
      return guardado;
    } finally {
      _enviando = false;
      notifyListeners();
    }
  }

  /// La cocina pasa el pedido al estado siguiente y se notifica al cliente.
  Future<void> avanzarEstado(int pedidoId) async {
    final actual = pedido(pedidoId);
    final siguiente = actual?.estado.siguiente;
    if (actual == null || siguiente == null) return;
    await cambiarEstado(pedidoId, siguiente);
  }

  Future<void> cambiarEstado(int pedidoId, EstadoPedido estado) async {
    final i = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (i < 0) return;
    final fecha = await _repo.cambiarEstado(pedidoId, estado);
    final actualizado =
        _pedidos[i].copiarCon(estado: estado, actualizado: fecha);
    _pedidos = [..._pedidos]..[i] = actualizado;
    notifyListeners();
    try {
      await _notificaciones.notificarEstado(actualizado);
    } catch (e) {
      debugPrint('Error al notificar: $e');
    }
  }
}
