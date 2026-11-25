# Cronograma y avance

Cronograma del documento de avances (S1–S13). **Estado: versión final, 100 % completado.**

| Semana | Actividad | Estado | Dónde está en el código |
|---|---|---|---|
| S1 | Prototipo en papel | ✅ | Documento de avances |
| S2 | Prototipo interactivo (Figma) | ✅ | Documento de avances |
| S3–S4 | Pantalla principal y navegación | ✅ | `screens/splash/`, `screens/principal/` (barra inferior), `core/routes/app_routes.dart` |
| S4–S5 | Catálogo y categoría de productos | ✅ | `screens/menu/`, `screens/categoria/`, `screens/buscar/` |
| S5–S6 | Detalles y disponibilidad de productos | ✅ | `screens/detalle_producto/`, `widgets/sello_agotado.dart` |
| S6–S7 | Carrito: agregar o eliminar productos | ✅ | `providers/carrito_provider.dart`, `screens/carrito/` |
| S7–S8 | Diseño de interfaz de pedidos y notificación push | ✅ | `screens/pedidos/` |
| S9 | Realización de pedidos y notificación push en segundo plano | ✅ | `providers/pedidos_provider.dart`, `services/notificacion_service.dart` |
| S9–S10 | Diseño de base de datos | ✅ | `docs/BASE_DE_DATOS.md` |
| S9–S10 | Implementación de base de datos | ✅ | `data/database/database_helper.dart` (versión 2 con migración), `data/repositories/` |
| S10–S11 | Gestión de inventario | ✅ | `screens/cocina/tabs/inventario_tab.dart` (stock editable, disponible/no disponible, stock bajo) |
| S10–S12 | Actualización de stock en tiempo real | ✅ | `providers/catalogo_provider.dart` → los cambios de cocina se ven al instante en el menú y el carrito se ajusta solo |
| S10–S12 | Integración de stock / productos | ✅ | `screens/cocina/tabs/productos_tab.dart`, `screens/cocina/formulario_producto_screen.dart` |
| S10–S11 | Pedidos en local (autoservicio) | ✅ | Turno, *Comer aquí / Para llevar*, panel de pedidos de cocina (`screens/cocina/tabs/pedidos_cocina_tab.dart`) |
| S10 | Inicio de sesión de cocina (requisito del equipo) | ✅ | `screens/cocina/login_cocina_screen.dart`, `data/repositories/usuario_repository.dart`, `providers/sesion_provider.dart` |
| S12 | Pruebas y corrección de errores | ✅ | `test/widget_test.dart` (carrito, stock, estados, seguridad) — ejecutar `flutter test` |
| S13 | Entrega y evaluación final | ✅ | `README.md`, `docs/MANUAL_COCINA.md`, `docs/REQUISITOS.md` |

## Alcance de la versión final

La app funciona **en un solo dispositivo** (decisión del equipo): el cliente hace su pedido y el personal de cocina entra con su usuario y contraseña en el mismo celular o tablet del local. Toda la información se guarda en SQLite. Si más adelante se quisiera usar varios celulares, solo habría que reemplazar los repositorios (`data/repositories/`) por unos que usen un servidor; las pantallas no cambian.

## Configuración manual de Android

Solo si no se pudo usar `tool/configurar_plataformas.dart`.

**`android/app/src/main/AndroidManifest.xml`** — antes de `<application`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

y dentro de `<application>`, antes de `</application>`:

```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

y también (evita la pantalla en negro en emuladores):

```xml
<meta-data android:name="io.flutter.embedding.android.EnableImpeller" android:value="false" />
```

**`android/app/build.gradle.kts`** (si el archivo es `build.gradle`, ver la variante abajo):

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        // ...lo que ya había
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

Variante `build.gradle` (Groovy): `coreLibraryDesugaringEnabled true` dentro de `compileOptions` y `coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'` en `dependencies`.

**iOS — `ios/Runner/AppDelegate.swift`**, después de `GeneratedPluginRegistrant.register(with: self)`:

```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```
