import 'package:flutter/material.dart';

import '../database/imagenes.dart';

/// Estados por los que pasa un pedido. La cocina los cambia desde su panel
/// y cada cambio se guarda en la base de datos (columna `pedidos.estado`).
enum EstadoPedido {
  recibido('recibido', 'Pedido recibido', 'El restaurante recibió tu pedido.',
      Icons.receipt_long, 'Iniciar preparación'),
  enPreparacion('en_preparacion', 'En preparación',
      'Nuestros chefs están preparando tu pedido.', Icons.soup_kitchen,
      'Marcar como listo'),
  listo('listo', '¡Listo para recoger!',
      'Acércate a la barra con tu número de turno.', Icons.room_service,
      'Marcar como entregado'),
  entregado('entregado', 'Entregado', '¡Buen provecho! Gracias por elegirnos.',
      Icons.check_circle, null);

  /// Texto que se guarda en la base de datos.
  final String valor;
  final String titulo;
  final String mensaje;
  final IconData icono;

  /// Texto del botón con el que la cocina pasa al siguiente estado.
  final String? accionCocina;

  const EstadoPedido(
      this.valor, this.titulo, this.mensaje, this.icono, this.accionCocina);

  /// Estado que sigue, o null si ya se entregó.
  EstadoPedido? get siguiente =>
      index + 1 < EstadoPedido.values.length ? EstadoPedido.values[index + 1] : null;

  bool get activo => this != EstadoPedido.entregado;

  static EstadoPedido desdeValor(String? valor) {
    for (final e in EstadoPedido.values) {
      if (e.valor == valor) return e;
    }
    return EstadoPedido.recibido;
  }
}

/// Producto dentro de un pedido ya realizado (copia de nombre y precio
/// para que el historial no cambie si luego cambia el menú).
class PedidoItem {
  final String productoId;
  final String nombre;
  final int precioUnitario;
  final int cantidad;

  const PedidoItem({
    required this.productoId,
    required this.nombre,
    required this.precioUnitario,
    required this.cantidad,
  });

  int get subtotal => precioUnitario * cantidad;

  String get imagen => 'assets/images/productos/$productoId.jpg';

  String? imagenUrl({int ancho = 200}) =>
      urlUnsplash(fotosProductos[productoId], ancho: ancho);

  factory PedidoItem.desdeMapa(Map<String, Object?> mapa) => PedidoItem(
        productoId: mapa['producto_id'] as String,
        nombre: mapa['nombre'] as String,
        precioUnitario: mapa['precio_unitario'] as int,
        cantidad: mapa['cantidad'] as int,
      );

  Map<String, Object?> aMapa(int pedidoId) => {
        'pedido_id': pedidoId,
        'producto_id': productoId,
        'nombre': nombre,
        'precio_unitario': precioUnitario,
        'cantidad': cantidad,
      };
}

class Pedido {
  final int? id;
  final DateTime fecha;
  final int subtotal;
  final int descuento;
  /// Siempre 0 (autoservicio). Se conserva por compatibilidad con la base.
  final int envio;
  final int total;
  final String? codigoPromocional;

  /// Autoservicio en el local: 'comer_aqui' o 'para_llevar'.
  final String tipoEntrega;
  final List<PedidoItem> items;

  /// Estado actual (lo cambia la cocina).
  final EstadoPedido estado;

  /// Última vez que cambió el estado.
  final DateTime? actualizado;

  const Pedido({
    this.id,
    required this.fecha,
    required this.subtotal,
    required this.descuento,
    required this.envio,
    required this.total,
    required this.codigoPromocional,
    required this.tipoEntrega,
    required this.items,
    this.estado = EstadoPedido.recibido,
    this.actualizado,
  });

  int get cantidadProductos => items.fold(0, (s, i) => s + i.cantidad);

  /// Número de turno que el cliente usa para recoger en la barra.
  String get turno => (id ?? 0).toString().padLeft(3, '0');
  String get codigo => 'Turno $turno';

  bool get paraLlevar => tipoEntrega == tipoParaLlevar;

  static const String tipoComerAqui = 'comer_aqui';
  static const String tipoParaLlevar = 'para_llevar';

  Pedido conId(int nuevoId) => copiarCon(id: nuevoId);

  Pedido copiarCon({int? id, EstadoPedido? estado, DateTime? actualizado}) =>
      Pedido(
        id: id ?? this.id,
        fecha: fecha,
        subtotal: subtotal,
        descuento: descuento,
        envio: envio,
        total: total,
        codigoPromocional: codigoPromocional,
        tipoEntrega: tipoEntrega,
        items: items,
        estado: estado ?? this.estado,
        actualizado: actualizado ?? this.actualizado,
      );

  factory Pedido.desdeMapa(Map<String, Object?> mapa, List<PedidoItem> items) =>
      Pedido(
        id: mapa['id'] as int,
        fecha: DateTime.fromMillisecondsSinceEpoch(mapa['fecha'] as int),
        subtotal: mapa['subtotal'] as int,
        descuento: mapa['descuento'] as int,
        envio: mapa['envio'] as int,
        total: mapa['total'] as int,
        codigoPromocional: mapa['codigo_promocional'] as String?,
        tipoEntrega: mapa['tipo_entrega'] as String,
        items: items,
        estado: EstadoPedido.desdeValor(mapa['estado'] as String?),
        actualizado: mapa['actualizado'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(mapa['actualizado'] as int),
      );

  Map<String, Object?> aMapa() => {
        if (id != null) 'id': id,
        'fecha': fecha.millisecondsSinceEpoch,
        'subtotal': subtotal,
        'descuento': descuento,
        'envio': envio,
        'total': total,
        'codigo_promocional': codigoPromocional,
        'tipo_entrega': tipoEntrega,
        'estado': estado.valor,
        'actualizado': actualizado?.millisecondsSinceEpoch,
      };
}
