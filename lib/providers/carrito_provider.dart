import 'package:flutter/foundation.dart';

import '../data/models/codigo_promocional.dart';
import '../data/models/item_carrito.dart';
import '../data/models/pedido.dart';
import '../data/models/producto.dart';

/// Resultado de intentar agregar un producto al carrito.
enum ResultadoAgregar { agregado, limiteStock, agotado }

/// Carrito de compras (Semanas 6-7): agregar, cambiar cantidad, eliminar,
/// aplicar código promocional y calcular totales.
/// Autoservicio en el local: no hay costo de envío.
class CarritoProvider extends ChangeNotifier {
  final Map<String, ItemCarrito> _items = {};
  CodigoPromocional? _codigo;
  String _tipoEntrega = Pedido.tipoComerAqui;

  /// 'comer_aqui' o 'para_llevar'.
  String get tipoEntrega => _tipoEntrega;

  void elegirTipoEntrega(String tipo) {
    _tipoEntrega = tipo;
    notifyListeners();
  }

  List<ItemCarrito> get items => _items.values.toList();
  bool get estaVacio => _items.isEmpty;
  CodigoPromocional? get codigoAplicado => _codigo;

  /// Número total de unidades (lo que muestra "Carrito (3 items)").
  int get cantidadTotal => _items.values.fold(0, (s, i) => s + i.cantidad);

  int cantidadDe(String productoId) => _items[productoId]?.cantidad ?? 0;

  int get subtotal => _items.values.fold(0, (s, i) => s + i.subtotal);
  int get descuento => _codigo?.calcularDescuento(subtotal) ?? 0;
  int get total => subtotal - descuento;

  ResultadoAgregar agregar(Producto producto, {int cantidad = 1}) {
    if (!producto.disponible) return ResultadoAgregar.agotado;

    final actual = cantidadDe(producto.id);
    final nueva = actual + cantidad;
    final permitida = nueva > producto.stock ? producto.stock : nueva;

    _items[producto.id] = ItemCarrito(producto: producto, cantidad: permitida);
    notifyListeners();
    return permitida < nueva
        ? ResultadoAgregar.limiteStock
        : ResultadoAgregar.agregado;
  }

  void incrementar(String productoId) {
    final item = _items[productoId];
    if (item == null || item.cantidad >= item.producto.stock) return;
    item.cantidad++;
    notifyListeners();
  }

  void disminuir(String productoId) {
    final item = _items[productoId];
    if (item == null) return;
    if (item.cantidad <= 1) {
      _items.remove(productoId);
    } else {
      item.cantidad--;
    }
    notifyListeners();
  }

  void eliminar(String productoId) {
    _items.remove(productoId);
    notifyListeners();
  }

  void aplicarCodigo(CodigoPromocional codigo) {
    _codigo = codigo;
    notifyListeners();
  }

  void quitarCodigo() {
    _codigo = null;
    notifyListeners();
  }

  /// Actualiza los productos del carrito con los datos más recientes del
  /// catálogo (por ejemplo, si la cocina cambió el stock o marcó un plato
  /// como no disponible) y ajusta o quita lo que ya no se puede pedir.
  /// Se llama automáticamente cada vez que cambia el catálogo.
  void sincronizarStock(Producto? Function(String id) buscar) {
    var cambio = false;
    for (final id in _items.keys.toList()) {
      final actualizado = buscar(id);
      if (actualizado == null || !actualizado.disponible) {
        _items.remove(id);
        cambio = true;
        continue;
      }
      final item = _items[id]!;
      final cantidad = item.cantidad > actualizado.stock
          ? actualizado.stock
          : item.cantidad;
      if (!identical(item.producto, actualizado) || cantidad != item.cantidad) {
        _items[id] = ItemCarrito(producto: actualizado, cantidad: cantidad);
        cambio = true;
      }
    }
    // Se avisa en la siguiente vuelta del ciclo de eventos porque este
    // método puede llamarse mientras Flutter está construyendo widgets.
    if (cambio) Future.microtask(notifyListeners);
  }

  void vaciar() {
    _items.clear();
    _codigo = null;
    notifyListeners();
  }
}
