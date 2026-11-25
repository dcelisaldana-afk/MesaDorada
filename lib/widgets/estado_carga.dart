import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Muestra un indicador de carga, un mensaje de error con "Reintentar" o
/// el contenido, según corresponda.
class EstadoCarga extends StatelessWidget {
  final bool cargando;
  final String? error;
  final VoidCallback alReintentar;
  final Widget child;

  const EstadoCarga({
    super.key,
    required this.cargando,
    required this.error,
    required this.alReintentar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primario),
      );
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: AppColors.agotado),
              const SizedBox(height: 12),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(
                onPressed: alReintentar,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    return child;
  }
}

/// Mensaje centrado con ícono para listas vacías.
class MensajeVacio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String? subtitulo;
  final Widget? accion;

  const MensajeVacio({
    super.key,
    required this.icono,
    required this.titulo,
    this.subtitulo,
    this.accion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0x1FC95A3C),
                shape: BoxShape.circle,
              ),
              child: Icon(icono, size: 44, color: AppColors.primario),
            ),
            const SizedBox(height: 18),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.texto),
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitulo!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textoSecundario),
              ),
            ],
            if (accion != null) ...[
              const SizedBox(height: 20),
              accion!,
            ],
          ],
        ),
      ),
    );
  }
}
