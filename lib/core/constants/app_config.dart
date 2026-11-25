/// Parámetros de negocio editables sin tocar las pantallas.
class AppConfig {
  AppConfig._();

  /// Tiempo entre cambios del slider de platos destacados (documento: 5 s).
  static const Duration intervaloSlider = Duration(seconds: 5);

  // ─────────────── Seguridad del panel de cocina (RNF-03 y RNF-04) ───────

  /// Usuario y contraseña con los que se crea la cuenta de cocina la
  /// primera vez que se abre la app. Cámbienla desde el panel
  /// (pestaña Ajustes → Cambiar contraseña).
  static const String usuarioCocinaInicial = 'cocina';
  static const String contrasenaCocinaInicial = 'Cocina2026';
  static const String nombreCocinaInicial = 'Personal de cocina';

  /// Intentos fallidos permitidos antes de bloquear el acceso.
  static const int maxIntentosFallidos = 5;

  /// Tiempo que dura el bloqueo tras superar los intentos fallidos.
  static const Duration duracionBloqueo = Duration(minutes: 5);

  /// La sesión de cocina se cierra sola tras este tiempo sin actividad.
  static const Duration inactividadMaxima = Duration(minutes: 30);
}
