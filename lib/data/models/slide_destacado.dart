/// Elemento del slider de platos destacados del Menú Principal.
class SlideDestacado {
  final String titulo;
  final String subtitulo;

  /// Producto al que lleva el slide al tocarlo.
  final String productoId;
  final String categoriaId;

  const SlideDestacado({
    required this.titulo,
    required this.subtitulo,
    required this.productoId,
    required this.categoriaId,
  });

  /// Imagen opcional en assets/images/slider/. Si no existe se usa la
  /// imagen del producto y, si tampoco existe, el ícono de la categoría.
  String get imagen => 'assets/images/slider/$productoId.jpg';
}
