import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Barra superior del prototipo: botón circular de regreso a la izquierda
/// (opcional) y título centrado.
class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  /// false en las pestañas principales (no hay a dónde regresar).
  final bool mostrarAtras;
  final List<Widget>? acciones;

  const BarraSuperior({
    super.key,
    required this.titulo,
    this.mostrarAtras = true,
    this.acciones,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      backgroundColor: AppColors.fondo,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 68,
      leading: !mostrarAtras
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Center(
                child: BotonCircular(
                  icono: Icons.arrow_back,
                  alPresionar: () => Navigator.maybePop(context),
                ),
              ),
            ),
      title: Text(
        titulo,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.texto,
        ),
      ),
      actions: acciones,
    );
  }
}

/// Botón redondo blanco con sombra suave.
class BotonCircular extends StatelessWidget {
  final IconData icono;
  final VoidCallback alPresionar;
  final Color fondo;
  final Color colorIcono;
  final double tamano;

  const BotonCircular({
    super.key,
    required this.icono,
    required this.alPresionar,
    this.fondo = Colors.white,
    this.colorIcono = AppColors.texto,
    this.tamano = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: fondo,
      shape: const CircleBorder(),
      elevation: fondo == Colors.white ? 1.5 : 0,
      shadowColor: const Color(0x33000000),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: alPresionar,
        child: SizedBox(
          width: tamano,
          height: tamano,
          child: Icon(icono, size: tamano * 0.5, color: colorIcono),
        ),
      ),
    );
  }
}
