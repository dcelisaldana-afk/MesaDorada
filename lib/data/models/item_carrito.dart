import 'producto.dart';

/// Línea del carrito: un producto y la cantidad elegida.
class ItemCarrito {
  final Producto producto;
  int cantidad;

  ItemCarrito({required this.producto, this.cantidad = 1});

  int get subtotal => producto.precio * cantidad;
}
