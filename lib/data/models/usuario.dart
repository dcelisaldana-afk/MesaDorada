/// Usuario del personal de cocina (administrador).
class Usuario {
  final int id;
  final String usuario;
  final String nombre;

  /// Por ahora solo existe el rol 'cocina'.
  final String rol;

  const Usuario({
    required this.id,
    required this.usuario,
    required this.nombre,
    required this.rol,
  });

  static const String rolCocina = 'cocina';

  factory Usuario.desdeMapa(Map<String, Object?> mapa) => Usuario(
        id: mapa['id'] as int,
        usuario: mapa['usuario'] as String,
        nombre: mapa['nombre'] as String,
        rol: mapa['rol'] as String,
      );
}
