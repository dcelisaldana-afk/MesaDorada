import '../constants/app_config.dart';

/// Reglas de bloqueo por intentos fallidos (RNF-04). Es lógica pura, sin
/// base de datos, para poder probarla con `flutter test`.
class PoliticaAcceso {
  final int maxIntentos;
  final Duration duracionBloqueo;

  const PoliticaAcceso({
    this.maxIntentos = AppConfig.maxIntentosFallidos,
    this.duracionBloqueo = AppConfig.duracionBloqueo,
  });

  /// true si la cuenta sigue bloqueada en el momento [ahora].
  bool estaBloqueado(DateTime? bloqueadoHasta, DateTime ahora) =>
      bloqueadoHasta != null && bloqueadoHasta.isAfter(ahora);

  /// Calcula el nuevo estado tras un intento fallido.
  ResultadoFallo registrarFallo(int intentosPrevios, DateTime ahora) {
    final intentos = intentosPrevios + 1;
    if (intentos >= maxIntentos) {
      return ResultadoFallo(
        intentos: 0,
        bloqueadoHasta: ahora.add(duracionBloqueo),
        intentosRestantes: 0,
      );
    }
    return ResultadoFallo(
      intentos: intentos,
      bloqueadoHasta: null,
      intentosRestantes: maxIntentos - intentos,
    );
  }
}

class ResultadoFallo {
  final int intentos;
  final DateTime? bloqueadoHasta;
  final int intentosRestantes;

  const ResultadoFallo({
    required this.intentos,
    required this.bloqueadoHasta,
    required this.intentosRestantes,
  });

  bool get bloqueo => bloqueadoHasta != null;
}
