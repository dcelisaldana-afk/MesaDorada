import 'package:flutter/material.dart';

import '../data/models/producto.dart';
import '../providers/carrito_provider.dart';

/// Muestra un aviso breve en la parte inferior.
void mostrarMensaje(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(texto),
      duration: const Duration(seconds: 2),
    ));
}

/// Aviso según el resultado de agregar un producto al carrito.
void mostrarResultadoAgregar(
    BuildContext context, Producto producto, ResultadoAgregar resultado) {
  switch (resultado) {
    case ResultadoAgregar.agregado:
      mostrarMensaje(context, '${producto.nombre} agregado al carrito');
      break;
    case ResultadoAgregar.limiteStock:
      mostrarMensaje(context,
          'Solo hay ${producto.stock} unidades disponibles de ${producto.nombre}');
      break;
    case ResultadoAgregar.agotado:
      mostrarMensaje(context, '${producto.nombre} está agotado');
      break;
  }
}
