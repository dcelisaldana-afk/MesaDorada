import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/constants/app_config.dart';
import '../../core/utils/seguridad.dart';
import 'datos_iniciales.dart';

/// Acceso único a la base de datos SQLite local.
///
/// Modelo de datos (versión 2):
///   categorias (id, nombre, orden)
///   productos  (id, categoria_id → categorias, nombre, ..., precio, stock,
///               habilitado, activo, imagen_url)
///   pedidos    (id, fecha, subtotal, descuento, envio, total,
///               codigo_promocional, tipo_entrega, estado, actualizado)
///   pedido_items (id, pedido_id → pedidos, producto_id, nombre,
///                 precio_unitario, cantidad)
///   codigos_promocionales (codigo, tipo, valor, activo)
///   resenas    (id, estrellas, comentario, fecha)
///   usuarios   (id, usuario, nombre, rol, hash, sal, intentos_fallidos,
///               bloqueado_hasta)   ← personal de cocina
///
/// Ver docs/BASE_DE_DATOS.md para el diagrama completo.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instancia = DatabaseHelper._();

  static const String _nombreArchivo = 'la_mesa_dorada.db';

  /// Versión de la estructura. 1 = Semana 9; 2 = módulo de cocina
  /// (estado de pedidos, disponibilidad manual, usuarios).
  static const int version = 2;

  Database? _db;

  Future<Database> get db async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: version,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, _) async {
        await _crearTablas(db);
        await _insertarDatosIniciales(db);
      },
      onUpgrade: (db, versionAnterior, _) async {
        // Migraciones: se conservan los pedidos y el stock existentes.
        if (versionAnterior < 2) await _migrarAVersion2(db);
      },
    );
  }

  /// Versión 1 → 2: columnas nuevas y tabla de usuarios.
  Future<void> _migrarAVersion2(Database db) async {
    await db.execute(
        'ALTER TABLE productos ADD COLUMN habilitado INTEGER NOT NULL DEFAULT 1');
    await db.execute(
        'ALTER TABLE productos ADD COLUMN activo INTEGER NOT NULL DEFAULT 1');
    await db.execute('ALTER TABLE productos ADD COLUMN imagen_url TEXT');
    await db.execute(
        "ALTER TABLE pedidos ADD COLUMN estado TEXT NOT NULL DEFAULT 'recibido'");
    await db.execute('ALTER TABLE pedidos ADD COLUMN actualizado INTEGER');
    // Los pedidos anteriores usaban estados simulados: se dan por entregados.
    await db.execute("UPDATE pedidos SET estado = 'entregado'");
    await _crearTablaUsuarios(db);
    await _insertarUsuarioInicial(db);
  }

  Future<void> _crearTablas(Database db) async {
    await db.execute('''
      CREATE TABLE categorias (
        id      TEXT PRIMARY KEY,
        nombre  TEXT NOT NULL,
        orden   INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE productos (
        id                TEXT PRIMARY KEY,
        categoria_id      TEXT NOT NULL REFERENCES categorias(id),
        nombre            TEXT NOT NULL,
        nombre_completo   TEXT NOT NULL,
        descripcion_corta TEXT NOT NULL,
        descripcion       TEXT NOT NULL,
        precio            INTEGER NOT NULL,
        stock             INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
        ingredientes      TEXT NOT NULL,
        habilitado        INTEGER NOT NULL DEFAULT 1,
        activo            INTEGER NOT NULL DEFAULT 1,
        imagen_url        TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pedidos (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha               INTEGER NOT NULL,
        subtotal            INTEGER NOT NULL,
        descuento           INTEGER NOT NULL DEFAULT 0,
        envio               INTEGER NOT NULL DEFAULT 0,
        total               INTEGER NOT NULL,
        codigo_promocional  TEXT,
        tipo_entrega        TEXT NOT NULL DEFAULT 'comer_aqui',
        estado              TEXT NOT NULL DEFAULT 'recibido',
        actualizado         INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE pedido_items (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        pedido_id       INTEGER NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
        producto_id     TEXT NOT NULL,
        nombre          TEXT NOT NULL,
        precio_unitario INTEGER NOT NULL,
        cantidad        INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE codigos_promocionales (
        codigo  TEXT PRIMARY KEY,
        tipo    TEXT NOT NULL,
        valor   INTEGER NOT NULL,
        activo  INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE resenas (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        estrellas   INTEGER NOT NULL,
        comentario  TEXT,
        fecha       INTEGER NOT NULL
      )
    ''');

    await _crearTablaUsuarios(db);

    await db.execute(
        'CREATE INDEX idx_productos_categoria ON productos(categoria_id)');
    await db.execute(
        'CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id)');
  }

  Future<void> _crearTablaUsuarios(Database db) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario           TEXT NOT NULL UNIQUE,
        nombre            TEXT NOT NULL,
        rol               TEXT NOT NULL DEFAULT 'cocina',
        hash              TEXT NOT NULL,
        sal               TEXT NOT NULL,
        intentos_fallidos INTEGER NOT NULL DEFAULT 0,
        bloqueado_hasta   INTEGER
      )
    ''');
  }

  /// Cuenta de cocina inicial (ver AppConfig). La contraseña se guarda
  /// como hash con sal, nunca en texto plano.
  Future<void> _insertarUsuarioInicial(DatabaseExecutor db) async {
    final sal = Seguridad.generarSal();
    await db.insert('usuarios', {
      'usuario': AppConfig.usuarioCocinaInicial,
      'nombre': AppConfig.nombreCocinaInicial,
      'rol': 'cocina',
      'hash': Seguridad.hashContrasena(AppConfig.contrasenaCocinaInicial, sal),
      'sal': sal,
    });
  }

  Future<void> _insertarDatosIniciales(Database db) async {
    await _insertarUsuarioInicial(db);
    final lote = db.batch();
    for (final c in categoriasIniciales) {
      lote.insert('categorias', c.aMapa());
    }
    for (final p in productosIniciales) {
      lote.insert('productos', p.aMapa());
    }
    for (final c in codigosIniciales) {
      lote.insert('codigos_promocionales', {
        'codigo': c[0],
        'tipo': c[1],
        'valor': c[2],
        'activo': 1,
      });
    }
    await lote.commit(noResult: true);
  }
}
