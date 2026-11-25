import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Utilidades de seguridad para las contraseñas del personal de cocina.
///
/// Las contraseñas NUNCA se guardan en texto plano: se guarda un "hash"
/// (huella) calculado con SHA-256 junto con una "sal" aleatoria distinta
/// para cada usuario. El hash se repite muchas veces para que adivinar
/// contraseñas por fuerza bruta sea lento.
class Seguridad {
  Seguridad._();

  static const int _iteraciones = 10000;

  /// Sal aleatoria de 16 bytes codificada en base64.
  static String generarSal() {
    final aleatorio = Random.secure();
    final bytes = List<int>.generate(16, (_) => aleatorio.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Calcula el hash de [contrasena] con la [sal] dada.
  static String hashContrasena(String contrasena, String sal) {
    List<int> resumen = utf8.encode('$sal:$contrasena');
    for (var i = 0; i < _iteraciones; i++) {
      resumen = sha256.convert(resumen).bytes;
    }
    return base64Url.encode(resumen);
  }

  /// Compara en tiempo constante para no dar pistas por el tiempo de
  /// respuesta.
  static bool verificar(String contrasena, String sal, String hashGuardado) {
    final calculado = hashContrasena(contrasena, sal);
    if (calculado.length != hashGuardado.length) return false;
    var diferencia = 0;
    for (var i = 0; i < calculado.length; i++) {
      diferencia |= calculado.codeUnitAt(i) ^ hashGuardado.codeUnitAt(i);
    }
    return diferencia == 0;
  }

  /// Reglas mínimas para una contraseña nueva. Devuelve el error o null.
  static String? validarContrasenaNueva(String contrasena) {
    if (contrasena.length < 8) return 'Debe tener al menos 8 caracteres.';
    if (!RegExp(r'[A-Za-z]').hasMatch(contrasena) ||
        !RegExp(r'[0-9]').hasMatch(contrasena)) {
      return 'Debe tener letras y números.';
    }
    return null;
  }
}
