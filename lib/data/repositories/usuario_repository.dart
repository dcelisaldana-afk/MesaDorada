import '../../core/utils/politica_acceso.dart';
import '../../core/utils/seguridad.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';

/// Resultado de un intento de inicio de sesión.
class ResultadoInicioSesion {
  final Usuario? usuario;
  final String? error;

  /// Si la cuenta quedó (o está) bloqueada, hasta cuándo.
  final DateTime? bloqueadoHasta;

  const ResultadoInicioSesion.exito(Usuario this.usuario)
      : error = null,
        bloqueadoHasta = null;

  const ResultadoInicioSesion.fallo(String this.error, {this.bloqueadoHasta})
      : usuario = null;

  bool get exitoso => usuario != null;
}

/// Acceso a la tabla `usuarios` (personal de cocina).
class UsuarioRepository {
  final DatabaseHelper _helper;
  final PoliticaAcceso _politica;

  UsuarioRepository([DatabaseHelper? helper, PoliticaAcceso? politica])
      : _helper = helper ?? DatabaseHelper.instancia,
        _politica = politica ?? const PoliticaAcceso();

  static const String _mensajeGenerico = 'Usuario o contraseña incorrectos.';

  Future<ResultadoInicioSesion> iniciarSesion(
      String usuario, String contrasena) async {
    final db = await _helper.db;
    final ahora = DateTime.now();
    final filas = await db.query('usuarios',
        where: 'LOWER(usuario) = ?',
        whereArgs: [usuario.trim().toLowerCase()],
        limit: 1);

    // No se dice si el usuario existe o no (evita adivinar usuarios).
    if (filas.isEmpty) return const ResultadoInicioSesion.fallo(_mensajeGenerico);
    final fila = filas.first;
    final id = fila['id'] as int;

    final bloqueadoMs = fila['bloqueado_hasta'] as int?;
    final bloqueadoHasta = bloqueadoMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(bloqueadoMs);
    if (_politica.estaBloqueado(bloqueadoHasta, ahora)) {
      return ResultadoInicioSesion.fallo(
        'Acceso bloqueado por demasiados intentos fallidos.',
        bloqueadoHasta: bloqueadoHasta,
      );
    }

    final valida = Seguridad.verificar(
        contrasena, fila['sal'] as String, fila['hash'] as String);

    if (!valida) {
      final r = _politica.registrarFallo(fila['intentos_fallidos'] as int, ahora);
      await db.update(
        'usuarios',
        {
          'intentos_fallidos': r.intentos,
          'bloqueado_hasta': r.bloqueadoHasta?.millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      if (r.bloqueo) {
        return ResultadoInicioSesion.fallo(
          'Demasiados intentos fallidos. Acceso bloqueado.',
          bloqueadoHasta: r.bloqueadoHasta,
        );
      }
      return ResultadoInicioSesion.fallo(
          '$_mensajeGenerico Te quedan ${r.intentosRestantes} intentos.');
    }

    await db.update('usuarios',
        {'intentos_fallidos': 0, 'bloqueado_hasta': null},
        where: 'id = ?', whereArgs: [id]);
    return ResultadoInicioSesion.exito(Usuario.desdeMapa(fila));
  }

  /// Cambia la contraseña verificando primero la actual. Devuelve el error
  /// o null si todo salió bien.
  Future<String?> cambiarContrasena(
      int usuarioId, String actual, String nueva) async {
    final regla = Seguridad.validarContrasenaNueva(nueva);
    if (regla != null) return regla;

    final db = await _helper.db;
    final filas = await db.query('usuarios',
        where: 'id = ?', whereArgs: [usuarioId], limit: 1);
    if (filas.isEmpty) return 'El usuario ya no existe.';
    final fila = filas.first;
    if (!Seguridad.verificar(
        actual, fila['sal'] as String, fila['hash'] as String)) {
      return 'La contraseña actual no es correcta.';
    }
    final sal = Seguridad.generarSal();
    await db.update(
      'usuarios',
      {'hash': Seguridad.hashContrasena(nueva, sal), 'sal': sal},
      where: 'id = ?',
      whereArgs: [usuarioId],
    );
    return null;
  }
}
