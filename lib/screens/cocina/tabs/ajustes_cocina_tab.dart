import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../providers/sesion_provider.dart';
import '../panel_cocina_screen.dart';

/// Ajustes del personal de cocina: datos de la sesión, cambio de
/// contraseña y cierre de sesión.
class AjustesCocinaTab extends StatelessWidget {
  const AjustesCocinaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<SesionProvider>().usuario;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.superficie,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0x33C95A3C),
                child: Icon(Icons.soup_kitchen, color: AppColors.primario),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario?.nombre ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    Text(
                      'Usuario: ${usuario?.usuario ?? ''} · Rol: cocina',
                      style: const TextStyle(
                          color: AppColors.textoSecundario, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: AppColors.superficie,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.password_rounded,
                    color: AppColors.primario),
                title: const Text('Cambiar contraseña',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _cambiarContrasena(context),
              ),
              const Divider(height: 1, color: AppColors.borde),
              ListTile(
                leading: const Icon(Icons.logout_rounded,
                    color: AppColors.primario),
                title: const Text('Cerrar sesión',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => cerrarSesionCocina(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Por seguridad, la sesión se cierra sola tras '
          '${AppConfig.inactividadMaxima.inMinutes} minutos sin uso y el acceso '
          'se bloquea ${AppConfig.duracionBloqueo.inMinutes} minutos después de '
          '${AppConfig.maxIntentosFallidos} intentos fallidos.',
          style: const TextStyle(color: AppColors.textoSecundario, fontSize: 12.5),
        ),
      ],
    );
  }

  Future<void> _cambiarContrasena(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_) => const _DialogoContrasena(),
      );
}

class _DialogoContrasena extends StatefulWidget {
  const _DialogoContrasena();

  @override
  State<_DialogoContrasena> createState() => _DialogoContrasenaState();
}

class _DialogoContrasenaState extends State<_DialogoContrasena> {
  final _actual = TextEditingController();
  final _nueva = TextEditingController();
  final _repetir = TextEditingController();
  String? _error;
  bool _guardando = false;

  @override
  void dispose() {
    _actual.dispose();
    _nueva.dispose();
    _repetir.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_nueva.text != _repetir.text) {
      setState(() => _error = 'Las contraseñas nuevas no coinciden.');
      return;
    }
    setState(() {
      _guardando = true;
      _error = null;
    });
    final sesion = context.read<SesionProvider>();
    final navegador = Navigator.of(context);
    final mensajero = ScaffoldMessenger.of(context);
    final error = await sesion.cambiarContrasena(_actual.text, _nueva.text);
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _guardando = false;
        _error = error;
      });
      return;
    }
    navegador.pop();
    mensajero.showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada')));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar contraseña'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _actual,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña actual'),
            ),
            TextField(
              controller: _nueva,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                helperText: 'Mínimo 8 caracteres, con letras y números',
              ),
            ),
            TextField(
              controller: _repetir,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Repite la nueva contraseña'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Color(0xFFB3261E))),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.primario),
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}

