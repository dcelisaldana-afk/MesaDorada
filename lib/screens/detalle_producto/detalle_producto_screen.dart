import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formato_moneda.dart';
import '../../providers/carrito_provider.dart';
import '../../providers/catalogo_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/boton_carrito.dart';
import '../../widgets/estado_carga.dart';
import '../../widgets/etiqueta_stock.dart';
import '../../widgets/icono_carrito.dart';
import '../../widgets/mensajes.dart';
import '../../widgets/selector_cantidad.dart';
import 'widgets/chip_ingrediente.dart';
import 'widgets/imagen_detalle.dart';

/// 4. Pantalla de Detalle de Producto (una sola pantalla para todos los
/// productos; solo cambia el contenido).
class DetalleProductoScreen extends StatefulWidget {
  final String productoId;

  const DetalleProductoScreen({super.key, required this.productoId});

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  int _cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final producto =
        context.watch<CatalogoProvider>().producto(widget.productoId);
    final enCarrito = context
        .select<CarritoProvider, int>((c) => c.cantidadDe(widget.productoId));

    if (producto == null) {
      return const Scaffold(
        appBar: BarraSuperior(titulo: ''),
        body: MensajeVacio(
          icono: Icons.search_off,
          titulo: 'Producto no encontrado',
        ),
      );
    }

    // Máximo que todavía se puede agregar según el stock.
    final maximo = producto.stock - enCarrito;
    final puedeAgregar = producto.disponible && maximo > 0;
    final tope = maximo < 1 ? 1 : maximo;
    final int cantidad =
        _cantidad < 1 ? 1 : (_cantidad > tope ? tope : _cantidad);
    final total = producto.precio * cantidad;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: producto.nombre,
        acciones: const [IconoCarrito(), SizedBox(width: 12)],
      ),
      bottomNavigationBar: BarraInferior(
        child: BotonPrincipal(
          icono: Icons.shopping_bag_outlined,
          texto: !producto.disponible
              ? 'Producto agotado'
              : maximo <= 0
                  ? 'Ya tienes todo el stock en el carrito'
                  : '${AppStrings.agregarAlCarrito} • ${formatoPesos(total)}',
          alPresionar: puedeAgregar
              ? () {
                  final resultado = context
                      .read<CarritoProvider>()
                      .agregar(producto, cantidad: cantidad);
                  if (resultado == ResultadoAgregar.agregado) {
                    // Flujo del prototipo: Detalle → Carrito
                    Navigator.pushReplacementNamed(context, AppRoutes.carrito);
                  } else {
                    mostrarResultadoAgregar(context, producto, resultado);
                  }
                }
              : null,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagenDetalle(producto: producto),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombreCompleto,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.texto,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stock visible para el cliente (se actualiza en vivo)
                  EtiquetaStock(producto: producto),
                  const SizedBox(height: 10),
                  Text(
                    producto.descripcion,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    AppStrings.ingredientesFrescos,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.texto,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: producto.ingredientes
                        .map((i) => ChipIngrediente(texto: i))
                        .toList(),
                  ),
                  const SizedBox(height: 22),
                  const Divider(color: AppColors.borde, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          AppStrings.cantidad,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.texto,
                          ),
                        ),
                      ),
                      SelectorCantidad(
                        cantidad: puedeAgregar ? cantidad : 0,
                        alDisminuir: puedeAgregar && cantidad > 1
                            ? () => setState(() => _cantidad = cantidad - 1)
                            : null,
                        alAumentar: puedeAgregar && cantidad < maximo
                            ? () => setState(() => _cantidad = cantidad + 1)
                            : null,
                      ),
                    ],
                  ),
                  if (enCarrito > 0) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Ya tienes $enCarrito en el carrito'
                      '${maximo > 0 ? ' · puedes agregar $maximo más' : ''}',
                      style: const TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
