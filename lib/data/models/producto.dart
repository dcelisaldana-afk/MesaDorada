import '../database/imagenes.dart';

/// Producto del menú.
///
/// Disponibilidad (lo que decide si sale "SOLD OUT"):
///   - [stock]: unidades que quedan. En 0 el producto se agota solo.
///   - [habilitado]: la cocina puede marcarlo como "no disponible" aunque
///     tenga stock (por ejemplo, si se acabó un ingrediente).
///   - [activo]: si es false el producto ya no aparece en el menú
///     (el administrador lo desactivó).
class Producto {
  /// Por debajo o igual a este número se considera "stock bajo".
  static const int limiteStockBajo = 5;

  final String id;
  final String categoriaId;

  /// Nombre corto (listado y barra superior del detalle). Ej: "Triple Carne".
  final String nombre;

  /// Nombre largo del detalle. Ej: "Triple Carne Suprema".
  final String nombreCompleto;

  /// Descripción corta del listado de la categoría.
  final String descripcionCorta;

  /// Descripción larga de la pantalla de detalle.
  final String descripcion;

  /// Precio en pesos colombianos (sin decimales).
  final int precio;
  final int stock;
  final List<String> ingredientes;
  final bool habilitado;
  final bool activo;

  /// Dirección de una foto propia (opcional, se configura desde el panel).
  final String? fotoUrl;

  const Producto({
    required this.id,
    required this.categoriaId,
    required this.nombre,
    required this.nombreCompleto,
    required this.descripcionCorta,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.ingredientes,
    this.habilitado = true,
    this.activo = true,
    this.fotoUrl,
  });

  /// Se puede pedir: está en el menú, la cocina no lo bloqueó y hay stock.
  bool get disponible => activo && habilitado && stock > 0;

  bool get stockBajo => activo && stock <= limiteStockBajo;

  /// Imagen esperada en assets (exportada desde Figma o descargada).
  String get imagen => 'assets/images/productos/$id.jpg';

  /// Foto en internet: la configurada en el panel o la de Unsplash.
  String? imagenUrl({int ancho = 600}) {
    final propia = fotoUrl;
    if (propia != null && propia.trim().isNotEmpty) return propia.trim();
    return urlUnsplash(fotosProductos[id], ancho: ancho);
  }

  Producto copiarCon({
    String? categoriaId,
    String? nombre,
    String? nombreCompleto,
    String? descripcionCorta,
    String? descripcion,
    int? precio,
    int? stock,
    List<String>? ingredientes,
    bool? habilitado,
    bool? activo,
    String? fotoUrl,
  }) =>
      Producto(
        id: id,
        categoriaId: categoriaId ?? this.categoriaId,
        nombre: nombre ?? this.nombre,
        nombreCompleto: nombreCompleto ?? this.nombreCompleto,
        descripcionCorta: descripcionCorta ?? this.descripcionCorta,
        descripcion: descripcion ?? this.descripcion,
        precio: precio ?? this.precio,
        stock: stock ?? this.stock,
        ingredientes: ingredientes ?? this.ingredientes,
        habilitado: habilitado ?? this.habilitado,
        activo: activo ?? this.activo,
        fotoUrl: fotoUrl ?? this.fotoUrl,
      );

  factory Producto.desdeMapa(Map<String, Object?> mapa) => Producto(
        id: mapa['id'] as String,
        categoriaId: mapa['categoria_id'] as String,
        nombre: mapa['nombre'] as String,
        nombreCompleto: mapa['nombre_completo'] as String,
        descripcionCorta: mapa['descripcion_corta'] as String,
        descripcion: mapa['descripcion'] as String,
        precio: mapa['precio'] as int,
        stock: mapa['stock'] as int,
        ingredientes: (mapa['ingredientes'] as String)
            .split('|')
            .where((e) => e.trim().isNotEmpty)
            .toList(),
        habilitado: ((mapa['habilitado'] as int?) ?? 1) == 1,
        activo: ((mapa['activo'] as int?) ?? 1) == 1,
        fotoUrl: mapa['imagen_url'] as String?,
      );

  Map<String, Object?> aMapa() => {
        'id': id,
        'categoria_id': categoriaId,
        'nombre': nombre,
        'nombre_completo': nombreCompleto,
        'descripcion_corta': descripcionCorta,
        'descripcion': descripcion,
        'precio': precio,
        'stock': stock,
        'ingredientes': ingredientes.join('|'),
        'habilitado': habilitado ? 1 : 0,
        'activo': activo ? 1 : 0,
        'imagen_url': fotoUrl,
      };
}
