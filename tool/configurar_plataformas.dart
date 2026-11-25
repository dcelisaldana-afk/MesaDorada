// Configura las carpetas android/ e ios/ del proyecto.
//
// Uso (desde la carpeta del proyecto, en la terminal de VS Code):
//   flutter pub get
//   dart run tool/configurar_plataformas.dart
//
// Qué hace:
//   1. Genera android/ e ios/ con `flutter create` (no sobrescribe lib/).
//   2. Agrega al AndroidManifest los permisos y receptores que necesitan
//      las notificaciones en segundo plano.
//   3. Activa "core library desugaring" en android/app/build.gradle(.kts)
//      (requisito de flutter_local_notifications).
//   4. Ajusta AppDelegate.swift para mostrar notificaciones en iOS.
//
// Se puede ejecutar varias veces sin dañar nada.

import 'dart:io';

const _nombreProyecto = 'la_mesa_dorada';
const _organizacion = 'co.edu.uts';
const _nombreVisible = 'La Mesa Dorada';
const _desugar = 'com.android.tools:desugar_jdk_libs:2.1.4';

Future<void> main() async {
  if (!File('pubspec.yaml').existsSync()) {
    _error('Ejecuta este script desde la carpeta raíz del proyecto.');
  }

  _titulo('1/4  Generando carpetas android/ e ios/');
  final codigo = await _ejecutar('flutter', [
    'create',
    '--org',
    _organizacion,
    '--project-name',
    _nombreProyecto,
    '--platforms=android,ios',
    '.',
  ]);
  if (codigo != 0) _error('`flutter create` falló (código $codigo).');

  _titulo('2/4  AndroidManifest.xml');
  _parchearManifest();

  _titulo('3/4  android/app/build.gradle');
  _parchearGradle();

  _titulo('4/4  iOS AppDelegate.swift');
  _parchearAppDelegate();

  stdout.writeln('\n✅ Listo. Ahora conecta tu celular (o abre un emulador) y ejecuta:');
  stdout.writeln('     flutter run\n');
}

// ───────────────────────────── Android ─────────────────────────────

void _parchearManifest() {
  final archivo = File('android/app/src/main/AndroidManifest.xml');
  if (!archivo.existsSync()) {
    _aviso('No se encontró ${archivo.path}');
    return;
  }
  var xml = archivo.readAsStringSync();

  const permisos = [
    'android.permission.INTERNET',
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.RECEIVE_BOOT_COMPLETED',
    'android.permission.VIBRATE',
  ];
  final faltantes = permisos
      .where((p) => !xml.contains('android:name="$p"'))
      .map((p) => '    <uses-permission android:name="$p"/>\n')
      .join();
  if (faltantes.isNotEmpty) {
    final i = xml.indexOf('<application');
    xml = xml.substring(0, i) + faltantes + xml.substring(i);
  }

  if (!xml.contains('ScheduledNotificationReceiver')) {
    const receptores = '''
        <!-- Notificaciones programadas (flutter_local_notifications) -->
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
''';
    final i = xml.lastIndexOf('</application>');
    xml = xml.substring(0, i) + receptores + '    ' + xml.substring(i);
  }

  // Usa el motor gráfico clásico (Skia/OpenGL). Evita la pantalla en negro
  // que el motor Impeller produce en varios emuladores y celulares.
  if (!xml.contains('EnableImpeller')) {
    const impeller = '''
        <meta-data android:name="io.flutter.embedding.android.EnableImpeller" android:value="false" />
''';
    final i = xml.lastIndexOf('</application>');
    xml = xml.substring(0, i) + impeller + '    ' + xml.substring(i);
  }

  xml = xml.replaceFirst(
      RegExp(r'android:label="[^"]*"'), 'android:label="$_nombreVisible"');

  archivo.writeAsStringSync(xml);
  _ok('Permisos, receptores y nombre de la app configurados');
}

void _parchearGradle() {
  final kts = File('android/app/build.gradle.kts');
  final groovy = File('android/app/build.gradle');
  final esKts = kts.existsSync();
  final archivo = esKts ? kts : groovy;
  if (!archivo.existsSync()) {
    _aviso('No se encontró android/app/build.gradle(.kts)');
    return;
  }
  var texto = archivo.readAsStringSync();

  if (texto.contains('oreLibraryDesugaringEnabled')) {
    _ok('Desugaring ya estaba activado');
    return;
  }

  final activar = esKts
      ? 'isCoreLibraryDesugaringEnabled = true'
      : 'coreLibraryDesugaringEnabled true';

  final bloque = RegExp(r'compileOptions\s*\{');
  final coincidencia = bloque.firstMatch(texto);
  if (coincidencia != null) {
    texto = texto.replaceRange(coincidencia.end, coincidencia.end,
        '\n        $activar');
  } else {
    final android = RegExp(r'android\s*\{').firstMatch(texto);
    if (android == null) {
      _aviso('No se encontró el bloque android { } en ${archivo.path}');
      return;
    }
    texto = texto.replaceRange(android.end, android.end,
        '\n    compileOptions {\n        $activar\n    }\n');
  }

  final dependencia = esKts
      ? 'coreLibraryDesugaring("$_desugar")'
      : "coreLibraryDesugaring '$_desugar'";
  texto += '\ndependencies {\n    $dependencia\n}\n';

  archivo.writeAsStringSync(texto);
  _ok('Desugaring activado en ${archivo.path}');
}

// ─────────────────────────────── iOS ───────────────────────────────

void _parchearAppDelegate() {
  final archivo = File('ios/Runner/AppDelegate.swift');
  if (!archivo.existsSync()) {
    _aviso('No hay carpeta ios/ (normal en Windows). Se omite.');
    return;
  }
  var texto = archivo.readAsStringSync();
  if (texto.contains('UNUserNotificationCenter')) {
    _ok('AppDelegate ya estaba configurado');
    return;
  }
  const registro = 'GeneratedPluginRegistrant.register(with: self)';
  if (!texto.contains(registro)) {
    _aviso('AppDelegate con formato distinto; ver README (sección iOS).');
    return;
  }
  texto = texto.replaceFirst('import UIKit', 'import UIKit\nimport UserNotifications');
  texto = texto.replaceFirst(registro, '''$registro
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }''');
  archivo.writeAsStringSync(texto);
  _ok('AppDelegate.swift configurado');
}

// ───────────────────────────── utilidades ─────────────────────────────

Future<int> _ejecutar(String comando, List<String> argumentos) async {
  final proceso = await Process.start(
    comando,
    argumentos,
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );
  return proceso.exitCode;
}

void _titulo(String t) => stdout.writeln('\n▶ $t');
void _ok(String t) => stdout.writeln('  ✔ $t');
void _aviso(String t) => stdout.writeln('  ⚠ $t');

Never _error(String t) {
  stderr.writeln('✖ $t');
  exit(1);
}
