import '../database/database_helper.dart';
import '../models/categoria.dart';
import '../models/codigo_promocional.dart';
import '../models/producto.dart';

/// Consultas del catálogo: categorías, productos, stock y códigos.
/// Si en el futuro los datos vienen de un servidor (API / Firebase),
/// solo se reemplaza esta clase; las pantallas no cambian.
class CatalogoRepository {
  final DatabaseHelper _helper;

  CatalogoRepository([DatabaseHelper? helper])
      : _helper = helper ?? DatabaseHelper.instancia;

  Future<List<Categoria>> obtenerCategorias() async {
    final db = await _helper.db;
    final filas = await db.query('categorias', orderBy: 'orden ASC');
    return filas.map(Categoria.desdeMapa).toList();
  }

  Future<List<Producto>> obtenerProductos() async {
    final db = await _helper.db;
    final filas = await db.query('productos', orderBy: 'rowid ASC');
    return filas.map(Producto.desdeMapa).toList();
  }

  // ───────────── Gestión desde el panel de cocina ─────────────

  /// Fija el stock de un producto (nunca negativo).
  Future<void> actualizarStock(String productoId, int stock) async {
    final db = await _helper.db;
    await db.update('productos', {'stock': stock < 0 ? 0 : stock},
        where: 'id = ?', whereArgs: [productoId]);
  }

  /// Marca un producto como disponible / no disponible (sin tocar el stock).
  Future<void> cambiarHabilitado(String productoId, bool habilitado) async {
    final db = await _helper.db;
    await db.update('productos', {'habilitado': habilitado ? 1 : 0},
        where: 'id = ?', whereArgs: [productoId]);
  }

  /// Muestra u oculta un producto del menú de los clientes.
  Future<void> cambiarActivo(String productoId, bool activo) async {
    final db = await _helper.db;
    await db.update('productos', {'activo': activo ? 1 : 0},
        where: 'id = ?', whereArgs: [productoId]);
  }

  /// Crea el producto si no existe o actualiza todos sus datos.
  Future<void> guardarProducto(Producto producto) async {
    final db = await _helper.db;
    final cambiados = await db.update('productos', producto.aMapa(),
        where: 'id = ?', whereArgs: [producto.id]);
    if (cambiados == 0) await db.insert('productos', producto.aMapa());
  }

  Future<bool> existeProducto(String id) async {
    final db = await _helper.db;
    final filas = await db.query('productos',
        columns: ['id'], where: 'id = ?', whereArgs: [id], limit: 1);
    return filas.isNotEmpty;
  }

  Future<CodigoPromocional?> buscarCodigo(String codigo) async {
    final db = await _helper.db;
    final filas = await db.query(
      'codigos_promocionales',
      where: 'UPPER(codigo) = ? AND activo = 1',
      whereArgs: [codigo.trim().toUpperCase()],
      limit: 1,
    );
    if (filas.isEmpty) return null;
    return CodigoPromocional.desdeMapa(filas.first);
  }

  Future<void> guardarResena(int estrellas, String? comentario) async {
    final db = await _helper.db;
    await db.insert('resenas', {
      'estrellas': estrellas,
      'comentario': comentario,
      'fecha': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
