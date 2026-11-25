import '../database/database_helper.dart';
import '../models/pedido.dart';

/// Guarda y consulta pedidos. Al guardar un pedido descuenta el stock de
/// cada producto dentro de la misma transacción, así el stock nunca queda
/// negativo ni el pedido a medias (RNF-05).
class PedidoRepository {
  final DatabaseHelper _helper;

  PedidoRepository([DatabaseHelper? helper])
      : _helper = helper ?? DatabaseHelper.instancia;

  /// Devuelve el pedido con su id asignado.
  /// Lanza [StockInsuficienteException] si algún producto se agotó.
  Future<Pedido> guardar(Pedido pedido) async {
    final db = await _helper.db;
    return db.transaction((txn) async {
      // 1. Verificar stock
      for (final item in pedido.items) {
        final filas = await txn.query('productos',
            columns: ['stock', 'habilitado', 'activo'],
            where: 'id = ?',
            whereArgs: [item.productoId]);
        final fila = filas.isEmpty ? null : filas.first;
        final pedible = fila != null &&
            fila['habilitado'] == 1 &&
            fila['activo'] == 1;
        final stock = pedible ? fila['stock'] as int : 0;
        if (stock < item.cantidad) {
          throw StockInsuficienteException(item.nombre, stock);
        }
      }

      // 2. Insertar pedido e items
      final id = await txn.insert('pedidos', pedido.aMapa());
      for (final item in pedido.items) {
        await txn.insert('pedido_items', item.aMapa(id));
        await txn.rawUpdate(
          'UPDATE productos SET stock = stock - ? WHERE id = ?',
          [item.cantidad, item.productoId],
        );
      }
      return pedido.conId(id);
    });
  }

  /// La cocina cambia el estado del pedido.
  Future<DateTime> cambiarEstado(int pedidoId, EstadoPedido estado) async {
    final db = await _helper.db;
    final ahora = DateTime.now();
    await db.update(
      'pedidos',
      {'estado': estado.valor, 'actualizado': ahora.millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [pedidoId],
    );
    return ahora;
  }

  Future<List<Pedido>> obtenerTodos() async {
    final db = await _helper.db;
    final filas = await db.query('pedidos', orderBy: 'fecha DESC');
    final pedidos = <Pedido>[];
    for (final fila in filas) {
      final items = await db.query('pedido_items',
          where: 'pedido_id = ?', whereArgs: [fila['id']]);
      pedidos.add(
          Pedido.desdeMapa(fila, items.map(PedidoItem.desdeMapa).toList()));
    }
    return pedidos;
  }
}

class StockInsuficienteException implements Exception {
  final String producto;
  final int disponible;

  StockInsuficienteException(this.producto, this.disponible);

  @override
  String toString() => disponible == 0
      ? '"$producto" se agotó.'
      : 'Solo quedan $disponible unidades de "$producto".';
}
