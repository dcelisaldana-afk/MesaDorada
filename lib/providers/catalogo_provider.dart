import 'package:flutter/foundation.dart';

import '../data/models/categoria.dart';
import '../data/models/producto.dart';
import '../data/repositories/catalogo_repository.dart';

/// Estado del catálogo (categorías y productos con su stock).
///
/// Es la única fuente de verdad para clientes y cocina: cuando la cocina
/// cambia el stock o la disponibilidad, se guarda en la base de datos y se
/// llama `notifyListeners()`, así el menú de los clientes se actualiza al
/// instante (tiempo real, RF-09).
class CatalogoProvider extends ChangeNotifier {
  final CatalogoRepository _repo;

  CatalogoProvider([CatalogoRepository? repo])
      : _repo = repo ?? CatalogoRepository();

  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  bool _cargando = false;
  String? _error;

  List<Categoria> get categorias => List.unmodifiable(_categorias);
  bool get cargando => _cargando;
  String? get error => _error;
  CatalogoRepository get repositorio => _repo;

  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _categorias = await _repo.obtenerCategorias();
      _productos = await _repo.obtenerProductos();
    } catch (e) {
      _error = 'No se pudo cargar el menú: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Recarga en silencio (por ejemplo, para actualizar el stock después
  /// de un pedido) sin mostrar el indicador de carga.
  Future<void> recargarStock() async {
    try {
      _productos = await _repo.obtenerProductos();
      notifyListeners();
    } catch (_) {/* se conserva la última versión */}
  }

  /// Productos que ven los clientes (los desactivados no aparecen).
  List<Producto> get todosLosProductos =>
      _productos.where((p) => p.activo).toList();

  List<Producto> productosDe(String categoriaId) => _productos
      .where((p) => p.categoriaId == categoriaId && p.activo)
      .toList();

  // ───────────────────────── Panel de cocina ─────────────────────────

  /// Todos los productos, incluidos los desactivados.
  List<Producto> get productosAdmin => List.unmodifiable(_productos);

  List<Producto> get productosStockBajo =>
      _productos.where((p) => p.stockBajo).toList();

  Future<void> actualizarStock(String productoId, int stock) async {
    final nuevo = stock < 0 ? 0 : stock;
    await _repo.actualizarStock(productoId, nuevo);
    _reemplazar(productoId, (p) => p.copiarCon(stock: nuevo));
  }

  Future<void> ajustarStock(String productoId, int cambio) async {
    final actual = producto(productoId);
    if (actual == null) return;
    await actualizarStock(productoId, actual.stock + cambio);
  }

  Future<void> cambiarHabilitado(String productoId, bool habilitado) async {
    await _repo.cambiarHabilitado(productoId, habilitado);
    _reemplazar(productoId, (p) => p.copiarCon(habilitado: habilitado));
  }

  Future<void> cambiarActivo(String productoId, bool activo) async {
    await _repo.cambiarActivo(productoId, activo);
    _reemplazar(productoId, (p) => p.copiarCon(activo: activo));
  }

  /// Crea o edita un producto desde el panel.
  Future<void> guardarProducto(Producto producto) async {
    await _repo.guardarProducto(producto);
    final i = _productos.indexWhere((p) => p.id == producto.id);
    if (i >= 0) {
      _productos[i] = producto;
    } else {
      _productos = [..._productos, producto];
    }
    notifyListeners();
  }

  /// Genera un id único a partir del nombre: "Pizza Napolitana" →
  /// "pizza_napolitana" (o "pizza_napolitana_2" si ya existe).
  String generarId(String nombre) {
    const con = 'áéíóúüñ';
    const sin = 'aeiouun';
    var base = nombre.toLowerCase().trim();
    for (var i = 0; i < con.length; i++) {
      base = base.replaceAll(con[i], sin[i]);
    }
    base = base
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    if (base.isEmpty) base = 'producto';
    var id = base;
    var n = 2;
    while (producto(id) != null) {
      id = '${base}_${n++}';
    }
    return id;
  }

  void _reemplazar(String id, Producto Function(Producto) cambio) {
    final i = _productos.indexWhere((p) => p.id == id);
    if (i < 0) return;
    _productos = [..._productos]..[i] = cambio(_productos[i]);
    notifyListeners();
  }

  Producto? producto(String id) {
    for (final p in _productos) {
      if (p.id == id) return p;
    }
    return null;
  }

  Categoria? categoria(String id) {
    for (final c in _categorias) {
      if (c.id == id) return c;
    }
    return null;
  }
}
