import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/catalogo_provider.dart';
import 'boton_carrito.dart';

/// Hoja inferior "Reséñanos": calificación de 1 a 5 estrellas + comentario.
/// La reseña se guarda en la tabla `resenas` de la base de datos.
Future<void> mostrarDialogoResena(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _HojaResena(),
  );
}

class _HojaResena extends StatefulWidget {
  const _HojaResena();

  @override
  State<_HojaResena> createState() => _HojaResenaState();
}

class _HojaResenaState extends State<_HojaResena> {
  int _estrellas = 0;
  bool _guardando = false;
  final _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    setState(() => _guardando = true);
    final repo = context.read<CatalogoProvider>().repositorio;
    final mensajero = ScaffoldMessenger.of(context);
    final navegador = Navigator.of(context);
    try {
      final texto = _comentario.text.trim();
      await repo.guardarResena(_estrellas, texto.isEmpty ? null : texto);
      navegador.pop();
      mensajero.showSnackBar(
        const SnackBar(content: Text('¡Gracias por tu reseña!')),
      );
    } catch (e) {
      setState(() => _guardando = false);
      mensajero.showSnackBar(
        SnackBar(content: Text('No se pudo guardar la reseña: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final teclado = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + teclado),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borde,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '¿Cómo fue tu experiencia?',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.texto),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final activa = i < _estrellas;
                return IconButton(
                  iconSize: 38,
                  onPressed: () => setState(() => _estrellas = i + 1),
                  icon: Icon(
                    activa ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: AppColors.estrella,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _comentario,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Cuéntanos qué te gustó (opcional)',
                filled: true,
                fillColor: AppColors.fondo,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            BotonPrincipal(
              texto: 'Enviar reseña',
              cargando: _guardando,
              alPresionar: _estrellas == 0 ? null : _enviar,
            ),
          ],
        ),
      ),
    );
  }
}
