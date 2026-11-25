import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/producto.dart';
import '../../providers/catalogo_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/boton_carrito.dart';
import '../../widgets/imagen_plato.dart';
import '../../widgets/mensajes.dart';

/// Crear o editar un producto del menú (integración de stock y productos).
/// [productoId] null = producto nuevo.
class FormularioProductoScreen extends StatefulWidget {
  final String? productoId;

  const FormularioProductoScreen({super.key, this.productoId});

  @override
  State<FormularioProductoScreen> createState() =>
      _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen> {
  final _formulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _nombreCompleto;
  late final TextEditingController _precio;
  late final TextEditingController _stock;
  late final TextEditingController _descripcionCorta;
  late final TextEditingController _descripcion;
  late final TextEditingController _ingredientes;
  late final TextEditingController _foto;
  String? _categoriaId;
  bool _habilitado = true;
  bool _activo = true;
  bool _guardando = false;
  Producto? _original;

  @override
  void initState() {
    super.initState();
    final catalogo = context.read<CatalogoProvider>();
    final p = widget.productoId == null
        ? null
        : catalogo.producto(widget.productoId!);
    _original = p;
    _nombre = TextEditingController(text: p?.nombre ?? '');
    _nombreCompleto = TextEditingController(text: p?.nombreCompleto ?? '');
    _precio = TextEditingController(text: p == null ? '' : '${p.precio}');
    _stock = TextEditingController(text: p == null ? '10' : '${p.stock}');
    _descripcionCorta = TextEditingController(text: p?.descripcionCorta ?? '');
    _descripcion = TextEditingController(text: p?.descripcion ?? '');
    _ingredientes =
        TextEditingController(text: p?.ingredientes.join(', ') ?? '');
    _foto = TextEditingController(text: p?.fotoUrl ?? '');
    _categoriaId = p?.categoriaId ??
        (catalogo.categorias.isEmpty ? null : catalogo.categorias.first.id);
    _habilitado = p?.habilitado ?? true;
    _activo = p?.activo ?? true;
  }

  @override
  void dispose() {
    for (final c in [
      _nombre,
      _nombreCompleto,
      _precio,
      _stock,
      _descripcionCorta,
      _descripcion,
      _ingredientes,
      _foto,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formulario.currentState!.validate()) return;
    final catalogo = context.read<CatalogoProvider>();
    final navegador = Navigator.of(context);
    setState(() => _guardando = true);

    final nombre = _nombre.text.trim();
    final completo = _nombreCompleto.text.trim();
    final corta = _descripcionCorta.text.trim();
    final larga = _descripcion.text.trim();
    final producto = Producto(
      id: _original?.id ?? catalogo.generarId(nombre),
      categoriaId: _categoriaId!,
      nombre: nombre,
      nombreCompleto: completo.isEmpty ? nombre : completo,
      descripcionCorta: corta,
      descripcion: larga.isEmpty ? corta : larga,
      precio: int.parse(_precio.text.trim()),
      stock: int.parse(_stock.text.trim()),
      ingredientes: _ingredientes.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      habilitado: _habilitado,
      activo: _activo,
      fotoUrl: _foto.text.trim().isEmpty ? null : _foto.text.trim(),
    );

    try {
      await catalogo.guardarProducto(producto);
      if (!mounted) return;
      mostrarMensaje(
          context,
          _original == null
              ? '${producto.nombre} se agregó al menú'
              : 'Cambios guardados');
      navegador.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      mostrarMensaje(context, 'No se pudo guardar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = context.watch<CatalogoProvider>().categorias;
    final nuevo = _original == null;

    return Scaffold(
      appBar: BarraSuperior(titulo: nuevo ? 'Nuevo producto' : 'Editar producto'),
      bottomNavigationBar: BarraInferior(
        child: BotonPrincipal(
          icono: Icons.save_outlined,
          texto: nuevo ? 'Agregar al menú' : 'Guardar cambios',
          cargando: _guardando,
          alPresionar: _guardar,
        ),
      ),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _foto,
              builder: (_, valor, __) => ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 150,
                  child: ImagenPlato(
                    rutas: [if (_original != null) _original!.imagen],
                    url: valor.text.trim().isNotEmpty
                        ? valor.text.trim()
                        : _original?.imagenUrl(ancho: 600),
                    categoriaId: _categoriaId ?? '',
                    tamanoIcono: 56,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _campo(_nombre, 'Nombre corto *', 'Ej: Pizza Napolitana',
                obligatorio: true, maximo: 30),
            _campo(_nombreCompleto, 'Nombre completo',
                'Se muestra en el detalle. Si lo dejas vacío se usa el nombre corto'),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<String>(
                initialValue: _categoriaId,
                decoration: _decoracion('Categoría *', null),
                items: [
                  for (final c in categorias)
                    DropdownMenuItem(value: c.id, child: Text(c.nombre)),
                ],
                onChanged: (v) => setState(() => _categoriaId = v),
                validator: (v) => v == null ? 'Elige una categoría' : null,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _campo(_precio, 'Precio (COP) *', 'Ej: 35900',
                      numero: true, obligatorio: true, minimo: 100),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _campo(_stock, 'Stock *', 'Unidades',
                      numero: true, obligatorio: true, minimo: 0),
                ),
              ],
            ),
            _campo(_descripcionCorta, 'Descripción corta *',
                'Se muestra en el listado de la categoría',
                obligatorio: true, lineas: 2),
            _campo(_descripcion, 'Descripción completa',
                'Se muestra en el detalle del producto',
                lineas: 3),
            _campo(_ingredientes, 'Ingredientes',
                'Separados por comas: Tomate, Queso, Albahaca'),
            _campo(_foto, 'Foto (dirección de internet, opcional)',
                'https://…', url: true),
            const SizedBox(height: 4),
            _interruptor(
              'Disponible para pedir',
              'Si lo apagas, los clientes lo verán como SOLD OUT.',
              _habilitado,
              (v) => setState(() => _habilitado = v),
            ),
            _interruptor(
              'Mostrar en el menú',
              'Si lo apagas, el producto se oculta del menú de clientes.',
              _activo,
              (v) => setState(() => _activo = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(
    TextEditingController c,
    String etiqueta,
    String ayuda, {
    bool obligatorio = false,
    bool numero = false,
    bool url = false,
    int lineas = 1,
    int? maximo,
    int? minimo,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        maxLines: lineas,
        maxLength: maximo,
        keyboardType: numero
            ? TextInputType.number
            : url
                ? TextInputType.url
                : TextInputType.text,
        inputFormatters:
            numero ? [FilteringTextInputFormatter.digitsOnly] : null,
        textCapitalization:
            url ? TextCapitalization.none : TextCapitalization.sentences,
        decoration: _decoracion(etiqueta, ayuda),
        validator: (v) {
          final t = (v ?? '').trim();
          if (obligatorio && t.isEmpty) return 'Campo obligatorio';
          if (numero && t.isNotEmpty) {
            final n = int.tryParse(t);
            if (n == null) return 'Escribe solo números';
            if (minimo != null && n < minimo) return 'Mínimo $minimo';
          }
          if (url && t.isNotEmpty && !t.startsWith('http')) {
            return 'Debe empezar por http:// o https://';
          }
          return null;
        },
      ),
    );
  }

  InputDecoration _decoracion(String etiqueta, String? ayuda) =>
      InputDecoration(
        labelText: etiqueta,
        helperText: ayuda,
        helperMaxLines: 2,
        filled: true,
        fillColor: AppColors.superficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
      );

  Widget _interruptor(
      String titulo, String ayuda, bool valor, ValueChanged<bool> alCambiar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borde),
      ),
      child: SwitchListTile(
        value: valor,
        onChanged: alCambiar,
        activeTrackColor: AppColors.exito,
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
        subtitle: Text(ayuda, style: const TextStyle(fontSize: 12.5)),
      ),
    );
  }
}
