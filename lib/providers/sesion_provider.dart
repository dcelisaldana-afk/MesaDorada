import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/app_config.dart';
import '../data/models/usuario.dart';
import '../data/repositories/usuario_repository.dart';

/// Sesión del personal de cocina.
///
/// - Inicia y cierra sesión contra la tabla `usuarios`.
/// - Cierra la sesión sola tras [AppConfig.inactividadMaxima] sin uso
///   (RNF-04). El panel llama [registrarActividad] cada vez que se toca.
class SesionProvider extends ChangeNotifier {
  final UsuarioRepository _repo;

  SesionProvider([UsuarioRepository? repo])
      : _repo = repo ?? UsuarioRepository();

  Usuario? _usuario;
  DateTime _ultimaActividad = DateTime.now();
  Timer? _vigilante;
  bool _cargando = false;
  bool _expiro = false;

  Usuario? get usuario => _usuario;
  bool get autenticado => _usuario != null;
  bool get cargando => _cargando;

  /// true si la última sesión se cerró por inactividad (para avisarlo).
  bool get expiro => _expiro;

  Future<ResultadoInicioSesion> iniciarSesion(
      String usuario, String contrasena) async {
    _cargando = true;
    notifyListeners();
    try {
      final r = await _repo.iniciarSesion(usuario, contrasena);
      if (r.exitoso) {
        _usuario = r.usuario;
        _expiro = false;
        registrarActividad();
        _vigilante?.cancel();
        _vigilante = Timer.periodic(
            const Duration(seconds: 30), (_) => _revisarInactividad());
      }
      return r;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void registrarActividad() => _ultimaActividad = DateTime.now();

  void _revisarInactividad() {
    if (!autenticado) return;
    if (DateTime.now().difference(_ultimaActividad) >=
        AppConfig.inactividadMaxima) {
      _expiro = true;
      cerrarSesion();
    }
  }

  void cerrarSesion() {
    _vigilante?.cancel();
    _vigilante = null;
    _usuario = null;
    notifyListeners();
  }

  Future<String?> cambiarContrasena(String actual, String nueva) {
    final u = _usuario;
    if (u == null) return Future.value('No hay una sesión iniciada.');
    registrarActividad();
    return _repo.cambiarContrasena(u.id, actual, nueva);
  }

  @override
  void dispose() {
    _vigilante?.cancel();
    super.dispose();
  }
}
