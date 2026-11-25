import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/producto.dart';
import '../../providers/carrito_provider.dart';
import '../../providers/catalogo_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/estado_carga.dart';
import '../../widgets/mensajes.dart';
import '../categoria/widgets/tarjeta_producto.dart';

/// Pestaña "Buscar": busca platos por nombre, descripción o ingrediente
/// y permite filtrar por categoría.
class BuscarScreen extends StatefulWidget {
  const BuscarScreen({super.key});

  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final _controlador = TextEditingController();
  String _texto = '';
  String? _categoriaId;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  /// Quita tildes y mayúsculas para comparar ("cesar" encuentra "César").
  static String _normalizar(String s) {
    const con = 'áéíóúüñ';
    const sin = 'aeiouun';
    var r = s.toLowerCase();
    for (var i = 0; i < con.length; i++) {
      r = r.replaceAll(con[i], sin[i]);
    }
    return r;
  }

  bool _coincide(Producto p) {
    if (_categoriaId != null && p.categoriaId != _categoriaId) return false;
    if (_texto.isEmpty) return true;
    final buscado = _normalizar(_texto);
    final contenido = _normalizar(
        '${p.nombre} ${p.nombreCompleto} ${p.descripcionCorta} ${p.ingredientes.join(' ')}');
    return contenido.contains(buscado);
  }

  @override
  Widget build(BuildContext context) {
    final catalogo = context.watch<CatalogoProvider>();
    final resultados = catalogo.todosLosProductos.where(_coincide).toList();

    return Scaffold(
      appBar: const BarraSuperior(titulo: AppStrings.buscar, mostrarAtras: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
            child: TextField(
              controller: _controlador,
              textInputAction: TextInputAction.search,
              onChanged: (v) => setState(() => _texto = v.trim()),
              decoration: InputDecoration(
                hintText: 'Busca un plato o ingrediente…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _texto.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controlador.clear();
                          setState(() => _texto = '');
                        },
                      ),
                filled: true,
                fillColor: AppColors.superficie,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: AppColors.borde),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: AppColors.borde),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: AppColors.primario),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _Filtro(
                  texto: 'Todas',
                  activo: _categoriaId == null,
                  alTocar: () => setState(() => _categoriaId = null),
                ),
                for (final c in catalogo.categorias)
                  _Filtro(
                    texto: c.nombre,
                    activo: _categoriaId == c.id,
                    alTocar: () => setState(() => _categoriaId = c.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: resultados.isEmpty
                ? const MensajeVacio(
                    icono: Icons.search_off_rounded,
                    titulo: 'Sin resultados',
                    subtitulo: 'Prueba con otro nombre o ingrediente.',
                  )
                : ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: resultados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, i) {
                      final producto = resultados[i];
                      return TarjetaProducto(
                        producto: producto,
                        alTocar: () => Navigator.pushNamed(
                          context,
                          AppRoutes.producto,
                          arguments: producto.id,
                        ),
                        alAgregar: () {
                          final r = context
                              .read<CarritoProvider>()
                              .agregar(producto);
                          mostrarResultadoAgregar(context, producto, r);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Filtro extends StatelessWidget {
  final String texto;
  final bool activo;
  final VoidCallback alTocar;

  const _Filtro({
    required this.texto,
    required this.activo,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: alTocar,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activo ? AppColors.texto : AppColors.superficie,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: activo ? AppColors.texto : AppColors.borde),
          ),
          child: Text(
            texto,
            style: TextStyle(
              color: activo ? Colors.white : AppColors.texto,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
