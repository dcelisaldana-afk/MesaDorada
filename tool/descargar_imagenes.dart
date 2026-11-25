// Descarga las fotos de los platos a assets/images/ para que la app las
// muestre sin internet y más rápido.
//
// Uso (desde la carpeta del proyecto):
//   dart run tool/descargar_imagenes.dart
// Luego detener la app y volver a ejecutar `flutter run`.
//
// Las fotos que ya existan no se vuelven a descargar.

import 'dart:io';

import 'package:la_mesa_dorada/data/database/imagenes.dart';

Future<void> main() async {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('Ejecuta este script desde la carpeta raíz del proyecto.');
    exit(1);
  }

  final cliente = HttpClient()..userAgent = 'LaMesaDorada/0.9';
  var ok = 0, fallidas = 0;

  Future<void> bajar(String foto, String destino, int ancho) async {
    final archivo = File(destino);
    if (archivo.existsSync() && archivo.lengthSync() > 0) {
      ok++;
      return;
    }
    final url = urlUnsplash(foto, ancho: ancho)!;
    try {
      final peticion = await cliente.getUrl(Uri.parse(url));
      final respuesta = await peticion.close();
      if (respuesta.statusCode != 200) {
        throw HttpException('HTTP ${respuesta.statusCode}');
      }
      archivo.parent.createSync(recursive: true);
      await respuesta.pipe(archivo.openWrite());
      ok++;
      stdout.writeln('  ✔ $destino');
    } catch (e) {
      fallidas++;
      stdout.writeln('  ✖ $destino ($e)');
    }
  }

  stdout.writeln('Descargando fotos de productos...');
  for (final e in fotosProductos.entries) {
    await bajar(e.value, 'assets/images/productos/${e.key}.jpg', 900);
  }
  stdout.writeln('Descargando fotos de categorías...');
  for (final e in fotosCategorias.entries) {
    await bajar(e.value, 'assets/images/categorias/${e.key}.jpg', 500);
  }
  cliente.close();

  stdout.writeln('\nListo: $ok fotos disponibles, $fallidas con error.');
  stdout.writeln('Detén la app y vuelve a ejecutar: flutter run');
}
