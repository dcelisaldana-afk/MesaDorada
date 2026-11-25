import 'package:flutter/material.dart';

import '../core/utils/iconos_categoria.dart';

/// Muestra la foto de un plato desde assets/images/.
///
/// Orden de búsqueda:
///   1. Las rutas locales en assets/ (la primera que exista).
///   2. La foto en internet [url] (mientras carga se ve el recuadro de color).
///   3. Si no hay ninguna, un recuadro con degradado y el ícono de la
///      categoría, para que la app nunca se vea rota.
class ImagenPlato extends StatelessWidget {
  final List<String> rutas;
  final String? url;
  final String categoriaId;
  final BoxFit fit;
  final bool enGris;
  final double tamanoIcono;

  const ImagenPlato({
    super.key,
    required this.rutas,
    this.url,
    required this.categoriaId,
    this.fit = BoxFit.cover,
    this.enGris = false,
    this.tamanoIcono = 40,
  });

  static const ColorFilter _filtroGris = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    final imagen = _construir(0);
    if (!enGris) return imagen;
    return ColorFiltered(colorFilter: _filtroGris, child: imagen);
  }

  Widget _construir(int indice) {
    if (indice >= rutas.length) return _desdeInternet();
    return Image.asset(
      rutas[indice],
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _construir(indice + 1),
    );
  }

  Widget _desdeInternet() {
    final direccion = url;
    if (direccion == null) return _respaldo();
    return Stack(
      fit: StackFit.expand,
      children: [
        _respaldo(),
        Image.network(
          direccion,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          // Aparece suavemente cuando termina de descargar.
          frameBuilder: (_, child, frame, sincrono) {
            if (sincrono) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: child,
            );
          },
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _respaldo() {
    final estilo = estiloCategoria(categoriaId);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: estilo.degradado,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(estilo.icono,
            size: tamanoIcono, color: const Color(0xE6FFFFFF)),
      ),
    );
  }
}
