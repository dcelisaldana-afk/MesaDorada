import '../database/imagenes.dart';

/// Categoría de comida (Hamburguesas, Pizzas, ...).
class Categoria {
  final String id;
  final String nombre;
  final int orden;

  const Categoria({
    required this.id,
    required this.nombre,
    required this.orden,
  });

  /// Imagen esperada en assets (exportada desde Figma).
  String get imagen => 'assets/images/categorias/$id.jpg';

  /// Foto en internet (se usa si no está la imagen local).
  String? imagenUrl({int ancho = 500}) =>
      urlUnsplash(fotosCategorias[id], ancho: ancho);

  factory Categoria.desdeMapa(Map<String, Object?> mapa) => Categoria(
        id: mapa['id'] as String,
        nombre: mapa['nombre'] as String,
        orden: mapa['orden'] as int,
      );

  Map<String, Object?> aMapa() => {
        'id': id,
        'nombre': nombre,
        'orden': orden,
      };
}
