# Trazabilidad de requisitos

Relación entre la especificación de requisitos del equipo y el código. Estado: **todos implementados**.

## Requisitos funcionales

| Código | Requisito | Dónde está |
|---|---|---|
| RF-01 | Menú principal con slider (5 s) y categorías | `screens/menu/` (`slider_destacados.dart`, `tarjeta_categoria.dart`) |
| RF-02 | Listado por categoría y detalle de producto | `screens/categoria/`, `screens/detalle_producto/` |
| RF-03 | Disponibilidad y SOLD OUT (por stock o marcado por cocina) | `Producto.disponible`, `widgets/sello_agotado.dart` |
| RF-04 | Búsqueda sin tildes y filtro por categoría | `screens/buscar/buscar_screen.dart` |
| RF-05 | Carrito con stock y código promocional | `providers/carrito_provider.dart`, `screens/carrito/` |
| RF-06 | Pedido con turno, comer aquí / para llevar | `providers/pedidos_provider.dart`, `data/repositories/pedido_repository.dart` |
| RF-07 | Notificaciones de cada cambio de estado | `services/notificacion_service.dart` (las dispara la cocina) |
| RF-08 | Inicio de sesión de cocina y panel exclusivo | `screens/cocina/login_cocina_screen.dart`, `screens/cocina/widgets/guardia_cocina.dart`, `screens/cocina/panel_cocina_screen.dart` |
| RF-09 | Editar stock y disponibilidad en tiempo real | `screens/cocina/tabs/inventario_tab.dart`, `providers/catalogo_provider.dart` |
| RF-10 | La cocina ve los pedidos y cambia su estado | `screens/cocina/tabs/pedidos_cocina_tab.dart` |

## Requisitos no funcionales

| Código | Requisito | Cómo se cumple |
|---|---|---|
| RNF-01 | Rendimiento | La app se dibuja antes de preparar las notificaciones (`main.dart`); imágenes con el ancho justo |
| RNF-02 | Tiempo real (≤ 5 s) | Un solo `CatalogoProvider`/`PedidosProvider` compartido: los cambios se ven al instante |
| RNF-03 | Seguridad del acceso | Hash SHA-256 con sal y 10 000 iteraciones (`core/utils/seguridad.dart`); rutas de cocina protegidas por `GuardiaCocina` |
| RNF-04 | Bloqueo y cierre de sesión | 5 intentos → 5 min (`core/utils/politica_acceso.dart`); 30 min sin uso (`providers/sesion_provider.dart`) |
| RNF-05 | Integridad del stock | Transacción en `PedidoRepository.guardar` + `CHECK (stock >= 0)` |
| RNF-06 | Usabilidad | Flujo de 4 pasos fiel al Figma; botones grandes |
| RNF-07 | Compatibilidad | Un solo código Flutter para Android e iOS |
| RNF-08 | Funciona sin internet | Todo en SQLite; fotos descargables con `tool/descargar_imagenes.dart` |
| RNF-09 | Notificaciones | `flutter_local_notifications` con canal de alta prioridad |
| RNF-10 | Accesibilidad | Colores con buen contraste, textos que respetan el tamaño de letra del sistema |
