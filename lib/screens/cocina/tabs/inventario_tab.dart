import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/producto.dart';
import '../../../providers/catalogo_provider.dart';
import '../../../widgets/estado_carga.dart';
import '../../../widgets/mensajes.dart';
import '../widgets/fila_inventario.dart';

enum _Filtro { todos, stockBajo, noDisponibles }

/// Inventario (RF-09): ver y editar el stock de cada producto y marcarlo
/// como disponible o no disponible. Los cambios se ven al instante en el
/// menú de los clientes.
class InventarioTab extends StatefulWidget {
  const InventarioTab({super.key});

  @override
  State<InventarioTab> createState() => _InventarioTabState();
}

class _InventarioTabState extends State<InventarioTab> {
  _Filtro _filtro = _Filtro.todos;
  String _texto = '';

  bool _pasaFiltro(Producto p) {
    if (!p.activo) return false; // los desactivados se gestionan en Productos
    if (_texto.isNotEmpty &&
        !p.nombre.toLowerCase().contains(_texto.toLowerCase())) {
      return false;
    }
    switch (_filtro) {
      case _Filtro.todos:
        return true;
      case _Filtro.stockBajo:
        return p.stockBajo;
      case _Filtro.noDisponibles:
        return !p.disponible;
    }
  }

  Future<void> _ejecutar(Future<void> Function() accion) async {
    try {
      await accion();
    } catch (e) {
      if (mounted) mostrarMensaje(context, 'No se pudo guardar: $e');
    }
  }

  Future<void> _editarStock(Producto p) async {
    final controlador = TextEditingController(text: '${p.stock}');
    final nuevo = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Stock de ${p.nombre}'),
        content: TextField(
          controller: controlador,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Unidades disponibles',
            suffixText: 'und.',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, int.tryParse(v.trim())),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primario),
            onPressed: () =>
                Navigator.pop(ctx, int.tryParse(controlador.text.trim())),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevo == null || !mounted) return;
    if (nuevo < 0) {
      mostrarMensaje(context, 'El stock no puede ser negativo.');
      return;
    }
    final catalogo = context.read<CatalogoProvider>();
    await _ejecutar(() => catalogo.actualizarStock(p.id, nuevo));
    if (mounted) mostrarMensaje(context, 'Stock de ${p.nombre}: $nuevo unidades');
  }

  @override
  Widget build(BuildContext context) {
    final catalogo = context.watch<CatalogoProvider>();
    final productos = catalogo.productosAdmin.where(_pasaFiltro).toList();
    final bajos = catalogo.productosStockBajo.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _texto = v.trim()),
            decoration: InputDecoration(
              hintText: 'Buscar producto…',
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              filled: true,
              fillColor: AppColors.superficie,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.borde),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.borde),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _chip('Todos', _Filtro.todos),
              _chip('Stock bajo ($bajos)', _Filtro.stockBajo),
              _chip('No disponibles', _Filtro.noDisponibles),
            ],
          ),
        ),
        if (bajos > 0 && _filtro == _Filtro.todos)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Material(
              color: const Color(0xFFFFF1DC),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _filtro = _Filtro.stockBajo),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFB26A00)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '$bajos ${bajos == 1 ? 'producto tiene' : 'productos tienen'} '
                          'stock bajo (${Producto.limiteStockBajo} o menos). Toca para verlos.',
                          style: const TextStyle(
                              color: Color(0xFF7A4A00), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 6),
        Expanded(
          child: productos.isEmpty
              ? const MensajeVacio(
                  icono: Icons.inventory_2_outlined,
                  titulo: 'Sin productos para mostrar',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  itemCount: productos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = productos[i];
                    final categoria = catalogo.categoria(p.categoriaId);
                    return FilaInventario(
                      producto: p,
                      categoria: categoria?.nombre ?? '',
                      alSumar: () =>
                          _ejecutar(() => catalogo.ajustarStock(p.id, 1)),
                      alRestar: p.stock > 0
                          ? () =>
                              _ejecutar(() => catalogo.ajustarStock(p.id, -1))
                          : null,
                      alEditarStock: () => _editarStock(p),
                      alCambiarDisponible: (v) => _ejecutar(
                          () => catalogo.cambiarHabilitado(p.id, v)),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _chip(String texto, _Filtro filtro) {
    final activo = _filtro == filtro;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: activo,
        showCheckmark: false,
        selectedColor: AppColors.texto,
        labelStyle: TextStyle(
          color: activo ? Colors.white : AppColors.texto,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) => setState(() => _filtro = filtro),
      ),
    );
  }
}
