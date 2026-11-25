import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/carrito_provider.dart';
import '../../../providers/catalogo_provider.dart';

/// Campo "Código promocional" + botón "Aplicar".
/// Códigos de prueba: MESA10, DORADA20, BIENVENIDO.
class CampoCodigoPromocional extends StatefulWidget {
  const CampoCodigoPromocional({super.key});

  @override
  State<CampoCodigoPromocional> createState() => _CampoCodigoPromocionalState();
}

class _CampoCodigoPromocionalState extends State<CampoCodigoPromocional> {
  final _controlador = TextEditingController();
  String? _error;
  bool _validando = false;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _aplicar() async {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _validando = true;
      _error = null;
    });
    final repo = context.read<CatalogoProvider>().repositorio;
    final carrito = context.read<CarritoProvider>();
    final codigo = await repo.buscarCodigo(texto).catchError((_) => null);
    if (!mounted) return;
    setState(() {
      _validando = false;
      if (codigo == null) {
        _error = 'Código no válido';
      } else {
        carrito.aplicarCodigo(codigo);
        _controlador.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final aplicado = context.watch<CarritoProvider>().codigoAplicado;

    if (aplicado != null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
        decoration: BoxDecoration(
          color: AppColors.chipFondo,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined,
                size: 18, color: AppColors.chipTexto),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${aplicado.codigo} · ${aplicado.descripcion}',
                style: const TextStyle(
                  color: AppColors.chipTexto,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Quitar código',
              onPressed: context.read<CarritoProvider>().quitarCodigo,
              icon: const Icon(Icons.close, size: 18, color: AppColors.chipTexto),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, right: 4),
          decoration: BoxDecoration(
            color: AppColors.superficie,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _error != null ? AppColors.primario : AppColors.borde,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controlador,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _aplicar(),
                  decoration: const InputDecoration(
                    hintText: AppStrings.codigoPromocional,
                    hintStyle: TextStyle(
                        color: AppColors.textoSecundario, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              _validando
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : TextButton(
                      onPressed: _aplicar,
                      child: const Text(
                        AppStrings.aplicar,
                        style: TextStyle(
                          color: AppColors.chipTexto,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ],
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 6),
            child: Text(
              _error!,
              style: const TextStyle(color: AppColors.primario, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
