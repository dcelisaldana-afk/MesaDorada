import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formato_fecha.dart';
import '../../providers/sesion_provider.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/boton_carrito.dart';
import '../../widgets/logo_restaurante.dart';

/// Inicio de sesión del personal de cocina (RF-08).
///
/// Solo quien tenga usuario y contraseña de cocina puede entrar al panel.
/// Tras 5 intentos fallidos el acceso se bloquea 5 minutos.
class LoginCocinaScreen extends StatefulWidget {
  const LoginCocinaScreen({super.key});

  @override
  State<LoginCocinaScreen> createState() => _LoginCocinaScreenState();
}

class _LoginCocinaScreenState extends State<LoginCocinaScreen> {
  final _formulario = GlobalKey<FormState>();
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();
  bool _ocultar = true;
  String? _error;
  DateTime? _bloqueadoHasta;
  Timer? _cuentaRegresiva;

  @override
  void dispose() {
    _usuario.dispose();
    _contrasena.dispose();
    _cuentaRegresiva?.cancel();
    super.dispose();
  }

  bool get _bloqueado =>
      _bloqueadoHasta != null && _bloqueadoHasta!.isAfter(DateTime.now());

  Future<void> _ingresar() async {
    if (_bloqueado) return;
    if (!_formulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final sesion = context.read<SesionProvider>();
    final navegador = Navigator.of(context);
    final r = await sesion.iniciarSesion(_usuario.text, _contrasena.text);
    if (!mounted) return;

    if (r.exitoso) {
      navegador.pushReplacementNamed(AppRoutes.panelCocina);
      return;
    }
    _contrasena.clear();
    setState(() {
      _error = r.error;
      _bloqueadoHasta = r.bloqueadoHasta;
    });
    if (_bloqueado) _iniciarCuentaRegresiva();
  }

  void _iniciarCuentaRegresiva() {
    _cuentaRegresiva?.cancel();
    _cuentaRegresiva = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (!_bloqueado) {
        t.cancel();
        setState(() {
          _bloqueadoHasta = null;
          _error = null;
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();
    final restante = _bloqueado
        ? _bloqueadoHasta!.difference(DateTime.now())
        : Duration.zero;

    return Scaffold(
      appBar: const BarraSuperior(titulo: 'Acceso cocina'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Form(
              key: _formulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primario,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Column(
                      children: [
                        LogoRestaurante(tamano: 84),
                        SizedBox(height: 12),
                        Text(
                          'Panel de cocina',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Solo personal autorizado',
                          style:
                              TextStyle(color: Color(0xDDFFFFFF), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (sesion.expiro) ...[
                    const SizedBox(height: 16),
                    const _Aviso(
                      icono: Icons.timer_off_outlined,
                      texto:
                          'Tu sesión se cerró por inactividad. Vuelve a iniciar sesión.',
                    ),
                  ],
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _usuario,
                    enabled: !_bloqueado,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    decoration: _decoracion('Usuario', Icons.person_outline),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Escribe tu usuario' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _contrasena,
                    enabled: !_bloqueado,
                    obscureText: _ocultar,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _ingresar(),
                    decoration: _decoracion('Contraseña', Icons.lock_outline)
                        .copyWith(
                      suffixIcon: IconButton(
                        tooltip: _ocultar ? 'Mostrar' : 'Ocultar',
                        icon: Icon(_ocultar
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _ocultar = !_ocultar),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Escribe tu contraseña' : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    _Aviso(
                      icono: _bloqueado
                          ? Icons.lock_clock_outlined
                          : Icons.error_outline,
                      texto: _bloqueado
                          ? '$_error Intenta de nuevo en ${formatoDuracion(restante)}.'
                          : _error!,
                      error: true,
                    ),
                  ],
                  const SizedBox(height: 22),
                  BotonPrincipal(
                    icono: Icons.login_rounded,
                    texto: 'Ingresar',
                    cargando: sesion.cargando,
                    alPresionar: _bloqueado ? null : _ingresar,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoracion(String etiqueta, IconData icono) =>
      InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        filled: true,
        fillColor: AppColors.superficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primario, width: 1.6),
        ),
      );
}

class _Aviso extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool error;

  const _Aviso({required this.icono, required this.texto, this.error = false});

  @override
  Widget build(BuildContext context) {
    final color = error ? const Color(0xFFB3261E) : AppColors.primario;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: error ? const Color(0xFFFBEAE8) : const Color(0x1FC95A3C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icono, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(texto,
                style: TextStyle(color: color, fontSize: 13.5)),
          ),
        ],
      ),
    );
  }
}
