# Manual del panel de cocina

## Entrar

1. En la app, abre la pestaña **Más** → **Acceso cocina (administrador)**.
2. Escribe el usuario y la contraseña de cocina.

| Usuario | Contraseña inicial |
|---|---|
| `cocina` | `Cocina2026` |

Cámbiala la primera vez desde **Ajustes → Cambiar contraseña** (mínimo 8 caracteres, con letras y números).

**Seguridad:**
- Tras **5 intentos fallidos** el acceso se bloquea **5 minutos**.
- La sesión se cierra sola tras **30 minutos sin uso**.
- La contraseña se guarda cifrada (hash con sal), nunca en texto plano.

## Pestañas del panel

### Pedidos
- **En curso:** los pedidos de los clientes llegan aquí al instante, del más antiguo al más nuevo. Cada tarjeta muestra el **turno**, si es *Comer aquí* o *Para llevar*, la hora y los productos.
- El botón de cada tarjeta pasa el pedido al siguiente estado y **envía la notificación al cliente**:
  - *Iniciar preparación* → "En preparación"
  - *Marcar como listo* → "¡Listo para recoger!" (el cliente va a la barra con su turno)
  - *Marcar como entregado* → "Entregado"
- **Entregados:** historial de pedidos ya atendidos.
- El número sobre el ícono de Pedidos indica cuántos pedidos nuevos no se han empezado.

### Inventario
- Muestra el **stock** de cada producto. Usa **− / +** o el lápiz para escribir la cantidad.
- El interruptor **Disponible / Pausado** permite ocultar un plato aunque tenga stock (por ejemplo, si se acabó un ingrediente). El cliente lo verá como **SOLD OUT**.
- Los productos con **5 unidades o menos** aparecen como *Stock bajo* y se cuentan en el ícono de Inventario.
- Cuando un producto llega a 0, pasa a *Agotado* automáticamente.
- Todos los cambios se ven **al instante** en el menú de los clientes; si un cliente tenía ese producto en el carrito, el carrito se ajusta solo.

### Productos
- **Nuevo producto:** nombre, categoría, precio, stock, descripciones, ingredientes y una foto opcional (dirección de internet).
- Toca un producto para **editarlo**.
- El interruptor de cada producto lo **muestra u oculta** del menú.

### Ajustes
- Datos de la sesión, **cambiar contraseña** y **cerrar sesión** (también con el ícono de salida arriba a la derecha).
