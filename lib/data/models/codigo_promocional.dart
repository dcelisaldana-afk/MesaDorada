/// Código de descuento aplicable en el carrito.
class CodigoPromocional {
  final String codigo;

  /// 'porcentaje' (valor = 10 -> 10 %) o 'valor' (valor = 5000 -> $5.000).
  final String tipo;
  final int valor;

  const CodigoPromocional({
    required this.codigo,
    required this.tipo,
    required this.valor,
  });

  int calcularDescuento(int subtotal) {
    final descuento =
        tipo == 'porcentaje' ? (subtotal * valor / 100).round() : valor;
    return descuento > subtotal ? subtotal : descuento;
  }

  String get descripcion =>
      tipo == 'porcentaje' ? '$valor % de descuento' : 'Descuento fijo';

  factory CodigoPromocional.desdeMapa(Map<String, Object?> mapa) =>
      CodigoPromocional(
        codigo: mapa['codigo'] as String,
        tipo: mapa['tipo'] as String,
        valor: mapa['valor'] as int,
      );
}
