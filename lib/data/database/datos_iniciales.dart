import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/slide_destacado.dart';

/// Datos con los que se llena la base de datos la primera vez que se abre
/// la app. Corresponden al prototipo de Figma.
///
/// Para agregar/editar un plato: modifica esta lista y aumenta
/// `DatabaseHelper.version` (o desinstala la app) para que se recargue.

const List<Categoria> categoriasIniciales = [
  Categoria(id: 'hamburguesas', nombre: 'Hamburguesas', orden: 1),
  Categoria(id: 'pizzas', nombre: 'Pizzas', orden: 2),
  Categoria(id: 'ensaladas', nombre: 'Ensaladas', orden: 3),
  Categoria(id: 'pastas', nombre: 'Pastas', orden: 4),
  Categoria(id: 'postres', nombre: 'Postres', orden: 5),
  Categoria(id: 'bebidas', nombre: 'Bebidas', orden: 6),
  Categoria(id: 'sopas', nombre: 'Sopas', orden: 7),
  Categoria(id: 'mariscos', nombre: 'Mariscos', orden: 8),
  Categoria(id: 'tacos', nombre: 'Tacos', orden: 9),
  Categoria(id: 'sushi', nombre: 'Sushi', orden: 10),
];

const List<SlideDestacado> slidesDestacados = [
  SlideDestacado(
    titulo: 'Hamburguesa Gourmet',
    subtitulo: 'Carne premium',
    productoId: 'triple_carne',
    categoriaId: 'hamburguesas',
  ),
  SlideDestacado(
    titulo: 'Pizza Artesanal',
    subtitulo: 'Masa madre en horno de leña',
    productoId: 'pizza_peperoni',
    categoriaId: 'pizzas',
  ),
  SlideDestacado(
    titulo: 'Sushi Fresco',
    subtitulo: 'Directo del mar',
    productoId: 'california_roll',
    categoriaId: 'sushi',
  ),
  SlideDestacado(
    titulo: 'Postre de la Casa',
    subtitulo: 'Tiramisú clásico',
    productoId: 'tiramisu',
    categoriaId: 'postres',
  ),
];

/// Códigos promocionales de prueba: [codigo, tipo, valor].
const List<List<Object>> codigosIniciales = [
  ['MESA10', 'porcentaje', 10],
  ['DORADA20', 'porcentaje', 20],
  ['BIENVENIDO', 'valor', 5000],
];

const List<Producto> productosIniciales = [
  // ───────────── HAMBURGUESAS ─────────────
  Producto(
    id: 'triple_carne',
    categoriaId: 'hamburguesas',
    nombre: 'Triple Carne',
    nombreCompleto: 'Triple Carne Suprema',
    descripcionCorta:
        'Tres hamburguesas premium, queso cheddar, salsa de la casa',
    descripcion:
        'La obra maestra de la casa. Triple ración de jugosa carne de res artesanal seleccionada.',
    precio: 45900,
    stock: 20,
    ingredientes: [
      'Carne de res',
      'Lechuga',
      'Tomate',
      'Queso cheddar',
      'Salsa especial'
    ],
  ),
  Producto(
    id: 'doble_queso',
    categoriaId: 'hamburguesas',
    nombre: 'Doble Queso',
    nombreCompleto: 'Doble Queso Angus',
    descripcionCorta:
        'Doble cheddar, carne angus, cebolla caramelizada, pepinillos',
    descripcion:
        'Para los amantes del queso. Carne angus a la parrilla con doble capa de cheddar fundido.',
    precio: 35900,
    stock: 20,
    ingredientes: [
      'Carne angus',
      'Doble cheddar',
      'Cebolla caramelizada',
      'Pepinillos',
      'Pan brioche'
    ],
  ),
  Producto(
    id: 'bbq_especial',
    categoriaId: 'hamburguesas',
    nombre: 'BBQ Especial',
    nombreCompleto: 'BBQ Especial Ahumada',
    descripcionCorta: 'Carne de res, tocineta, aros de cebolla, salsa BBQ',
    descripcion:
        'Sabor ahumado intenso. Carne de res con tocineta crujiente y nuestra salsa BBQ casera.',
    precio: 38900,
    stock: 0, // SOLD OUT (como en el prototipo)
    ingredientes: [
      'Carne de res',
      'Tocineta',
      'Aros de cebolla',
      'Salsa BBQ',
      'Queso cheddar'
    ],
  ),
  Producto(
    id: 'clasica',
    categoriaId: 'hamburguesas',
    nombre: 'Clásica',
    nombreCompleto: 'Hamburguesa Clásica',
    descripcionCorta:
        'Lechuga fresca, tomate jugoso, queso americano, mayonesa',
    descripcion:
        'La de siempre, hecha como nunca. Carne de res, vegetales frescos y queso americano.',
    precio: 29900,
    stock: 20,
    ingredientes: [
      'Carne de res',
      'Lechuga fresca',
      'Tomate',
      'Queso americano',
      'Mayonesa'
    ],
  ),

  // ───────────── PIZZAS ─────────────
  Producto(
    id: 'pizza_peperoni',
    categoriaId: 'pizzas',
    nombre: 'Pizza de Peperoni',
    nombreCompleto: 'Pizza de Peperoni',
    descripcionCorta:
        'Masa artesanal, peperoni premium, salsa de tomate, mozzarella',
    descripcion:
        'Nuestra pizza estrella. Masa artesanal horneada en horno de leña con peperoni premium importado.',
    precio: 54900,
    stock: 15,
    ingredientes: [
      'Masa artesanal',
      'Peperoni',
      'Mozzarella',
      'Salsa de tomate',
      'Orégano'
    ],
  ),
  Producto(
    id: 'pizza_margarita',
    categoriaId: 'pizzas',
    nombre: 'Pizza Margarita',
    nombreCompleto: 'Pizza Margarita',
    descripcionCorta:
        'Tomate fresco, mozzarella de búfala, albahaca, aceite de oliva',
    descripcion:
        'La reina de Nápoles. Tomate fresco, mozzarella de búfala y albahaca recién cortada.',
    precio: 49900,
    stock: 15,
    ingredientes: [
      'Mozzarella de búfala',
      'Tomate fresco',
      'Albahaca',
      'Aceite de oliva'
    ],
  ),
  Producto(
    id: 'pizza_hawaiana',
    categoriaId: 'pizzas',
    nombre: 'Pizza Hawaiana',
    nombreCompleto: 'Pizza Hawaiana',
    descripcionCorta:
        'Jamón ahumado, piña caramelizada, queso mozzarella fundido',
    descripcion:
        'El equilibrio perfecto entre dulce y salado, con piña caramelizada y jamón ahumado.',
    precio: 47900,
    stock: 0,
    ingredientes: ['Jamón ahumado', 'Piña caramelizada', 'Mozzarella'],
  ),
  Producto(
    id: 'pizza_4_quesos',
    categoriaId: 'pizzas',
    nombre: 'Pizza 4 Quesos',
    nombreCompleto: 'Pizza Cuatro Quesos',
    descripcionCorta:
        'Mozzarella, gorgonzola, parmesano, queso de cabra artesanal',
    descripcion:
        'Cuatro quesos seleccionados fundidos sobre nuestra masa artesanal.',
    precio: 59900,
    stock: 15,
    ingredientes: [
      'Mozzarella',
      'Gorgonzola',
      'Parmesano',
      'Queso de cabra'
    ],
  ),

  // ───────────── ENSALADAS ─────────────
  Producto(
    id: 'ensalada_cesar',
    categoriaId: 'ensaladas',
    nombre: 'Ensalada César',
    nombreCompleto: 'Ensalada César',
    descripcionCorta:
        'Lechuga romana, crutones dorados, parmesano, aderezo césar',
    descripcion:
        'Frescura en cada bocado. Lechuga romana crujiente con nuestro aderezo césar de la casa.',
    precio: 34900,
    stock: 15,
    ingredientes: [
      'Lechuga romana',
      'Crutones',
      'Parmesano',
      'Aderezo césar',
      'Pollo grillé'
    ],
  ),
  Producto(
    id: 'ensalada_griega',
    categoriaId: 'ensaladas',
    nombre: 'Ensalada Griega',
    nombreCompleto: 'Ensalada Griega',
    descripcionCorta:
        'Pepino, tomate, aceitunas kalamata, queso feta, orégano',
    descripcion:
        'Un viaje al Mediterráneo con queso feta, aceitunas kalamata y vegetales frescos.',
    precio: 32900,
    stock: 15,
    ingredientes: ['Pepino', 'Tomate', 'Aceitunas kalamata', 'Queso feta'],
  ),
  Producto(
    id: 'ensalada_tropical',
    categoriaId: 'ensaladas',
    nombre: 'Ensalada Tropical',
    nombreCompleto: 'Ensalada Tropical',
    descripcionCorta: 'Mango, aguacate, pollo a la parrilla, vinagreta cítrica',
    descripcion:
        'Colores y sabores del trópico con mango maduro, aguacate y pollo a la parrilla.',
    precio: 38900,
    stock: 0,
    ingredientes: ['Mango', 'Aguacate', 'Pollo a la parrilla', 'Vinagreta'],
  ),
  Producto(
    id: 'ensalada_chef',
    categoriaId: 'ensaladas',
    nombre: 'Ensalada del Chef',
    nombreCompleto: 'Ensalada del Chef',
    descripcionCorta:
        'Mix de lechugas, jamón, huevo cocido, queso suizo, vinagreta',
    descripcion:
        'La receta de nuestro chef: mix de lechugas, jamón, huevo y queso suizo.',
    precio: 36900,
    stock: 15,
    ingredientes: [
      'Mix de lechugas',
      'Jamón',
      'Huevo cocido',
      'Queso suizo'
    ],
  ),

  // ───────────── PASTAS ─────────────
  Producto(
    id: 'pasta_trufada',
    categoriaId: 'pastas',
    nombre: 'Pasta Trufada',
    nombreCompleto: 'Pasta Trufada',
    descripcionCorta: 'Fettuccine con crema de trufa negra, parmesano rallado',
    descripcion:
        'Un lujo italiano. Fettuccine al dente bañado en una sedosa crema de trufa negra artesanal.',
    precio: 62900,
    stock: 10,
    ingredientes: [
      'Fettuccine',
      'Trufa negra',
      'Parmesano',
      'Crema',
      'Mantequilla'
    ],
  ),
  Producto(
    id: 'fettuccine_alfredo',
    categoriaId: 'pastas',
    nombre: 'Fettuccine Alfredo',
    nombreCompleto: 'Fettuccine Alfredo',
    descripcionCorta:
        'Salsa cremosa de parmesano, mantequilla, ajo rostizado',
    descripcion:
        'Cremosidad absoluta con parmesano, mantequilla y un toque de ajo rostizado.',
    precio: 49900,
    stock: 10,
    ingredientes: ['Fettuccine', 'Parmesano', 'Mantequilla', 'Ajo rostizado'],
  ),
  Producto(
    id: 'lasana_clasica',
    categoriaId: 'pastas',
    nombre: 'Lasaña Clásica',
    nombreCompleto: 'Lasaña Clásica',
    descripcionCorta:
        'Capas de pasta, carne de res, bechamel, queso gratinado',
    descripcion:
        'Capas de pasta fresca con carne de res, salsa bechamel y queso gratinado al horno.',
    precio: 54900,
    stock: 0,
    ingredientes: ['Pasta fresca', 'Carne de res', 'Bechamel', 'Queso'],
  ),
  Producto(
    id: 'spaghetti_bolognesa',
    categoriaId: 'pastas',
    nombre: 'Spaghetti Bolognesa',
    nombreCompleto: 'Spaghetti a la Bolognesa',
    descripcionCorta:
        'Salsa de carne de res, tomate, hierbas italianas frescas',
    descripcion:
        'El clásico de Bolonia: salsa de carne cocinada a fuego lento con tomate y hierbas.',
    precio: 44900,
    stock: 10,
    ingredientes: ['Spaghetti', 'Carne de res', 'Tomate', 'Hierbas italianas'],
  ),

  // ───────────── POSTRES ─────────────
  Producto(
    id: 'tiramisu',
    categoriaId: 'postres',
    nombre: 'Tiramisú',
    nombreCompleto: 'Tiramisú Clásico',
    descripcionCorta: 'Bizcocho de café espresso, mascarpone, cacao en polvo',
    descripcion:
        'El postre italiano por excelencia. Capas de bizcocho empapado en café espresso y mascarpone.',
    precio: 24900,
    stock: 12,
    ingredientes: [
      'Mascarpone',
      'Café espresso',
      'Bizcocho',
      'Cacao',
      'Amaretto'
    ],
  ),
  Producto(
    id: 'brownie_helado',
    categoriaId: 'postres',
    nombre: 'Brownie con Helado',
    nombreCompleto: 'Brownie con Helado',
    descripcionCorta:
        'Brownie de chocolate belga, helado de vainilla artesanal',
    descripcion:
        'Brownie tibio de chocolate belga acompañado de helado de vainilla artesanal.',
    precio: 22900,
    stock: 12,
    ingredientes: ['Chocolate belga', 'Helado de vainilla', 'Nueces'],
  ),
  Producto(
    id: 'cheesecake',
    categoriaId: 'postres',
    nombre: 'Cheesecake',
    nombreCompleto: 'Cheesecake de Frutos Rojos',
    descripcionCorta:
        'Base de galleta, crema de queso, coulis de frutos rojos',
    descripcion:
        'Suave crema de queso sobre base de galleta, cubierta con coulis de frutos rojos.',
    precio: 26900,
    stock: 0,
    ingredientes: ['Crema de queso', 'Galleta', 'Frutos rojos'],
  ),
  Producto(
    id: 'flan_caramelo',
    categoriaId: 'postres',
    nombre: 'Flan de Caramelo',
    nombreCompleto: 'Flan de Caramelo',
    descripcionCorta: 'Flan casero con caramelo dorado, crema batida fresca',
    descripcion:
        'Receta casera de la abuela con caramelo dorado y crema batida fresca.',
    precio: 19900,
    stock: 12,
    ingredientes: ['Huevo', 'Leche', 'Caramelo', 'Crema batida'],
  ),

  // ───────────── BEBIDAS ─────────────
  Producto(
    id: 'limonada_natural',
    categoriaId: 'bebidas',
    nombre: 'Limonada Natural',
    nombreCompleto: 'Limonada Natural',
    descripcionCorta: 'Limones frescos, hierbabuena, sin azúcar añadida',
    descripcion:
        'Refrescante y revitalizante. Limones recién exprimidos con un toque de hierbabuena fresca.',
    precio: 9900,
    stock: 30,
    ingredientes: [
      'Limón fresco',
      'Hierbabuena',
      'Agua mineral',
      'Hielo',
      'Miel'
    ],
  ),
  Producto(
    id: 'jugo_mango',
    categoriaId: 'bebidas',
    nombre: 'Jugo de Mango',
    nombreCompleto: 'Jugo de Mango',
    descripcionCorta: 'Mango maduro seleccionado, agua mineral, hielo',
    descripcion: 'Mango maduro seleccionado, licuado al momento.',
    precio: 11900,
    stock: 30,
    ingredientes: ['Mango', 'Agua mineral', 'Hielo'],
  ),
  Producto(
    id: 'smoothie_fresa',
    categoriaId: 'bebidas',
    nombre: 'Smoothie de Fresa',
    nombreCompleto: 'Smoothie de Fresa',
    descripcionCorta: 'Fresas frescas, yogurt natural, miel de abejas, hielo',
    descripcion: 'Cremoso y natural: fresas frescas con yogurt y miel de abejas.',
    precio: 14900,
    stock: 0,
    ingredientes: ['Fresas', 'Yogurt natural', 'Miel', 'Hielo'],
  ),
  Producto(
    id: 'malteada_chocolate',
    categoriaId: 'bebidas',
    nombre: 'Malteada de Chocolate',
    nombreCompleto: 'Malteada de Chocolate',
    descripcionCorta: 'Helado artesanal, leche entera, chocolate belga',
    descripcion:
        'Helado artesanal batido con leche entera y chocolate belga.',
    precio: 16900,
    stock: 30,
    ingredientes: ['Helado artesanal', 'Leche entera', 'Chocolate belga'],
  ),

  // ───────────── SOPAS ─────────────
  Producto(
    id: 'sopa_tortilla',
    categoriaId: 'sopas',
    nombre: 'Sopa de Tortilla',
    nombreCompleto: 'Sopa de Tortilla',
    descripcionCorta: 'Tortilla crujiente, aguacate, crema agria, chile pasilla',
    descripcion:
        'Tradición mexicana en un tazón. Caldo especiado con tortillas crujientes y aguacate cremoso.',
    precio: 28900,
    stock: 15,
    ingredientes: [
      'Tortilla frita',
      'Aguacate',
      'Crema agria',
      'Chile pasilla',
      'Cilantro'
    ],
  ),
  Producto(
    id: 'crema_tomate',
    categoriaId: 'sopas',
    nombre: 'Crema de Tomate',
    nombreCompleto: 'Crema de Tomate',
    descripcionCorta: 'Tomates asados, albahaca fresca, crema, crutones dorados',
    descripcion:
        'Tomates asados lentamente, licuados con albahaca y un toque de crema.',
    precio: 24900,
    stock: 15,
    ingredientes: ['Tomates asados', 'Albahaca', 'Crema', 'Crutones'],
  ),
  Producto(
    id: 'sopa_azteca',
    categoriaId: 'sopas',
    nombre: 'Sopa Azteca',
    nombreCompleto: 'Sopa Azteca',
    descripcionCorta: 'Pollo desmenuzado, aguacate, chipotle, queso fresco',
    descripcion:
        'Caldo de tomate y chipotle con pollo desmenuzado, aguacate y queso fresco.',
    precio: 32900,
    stock: 0,
    ingredientes: ['Pollo', 'Aguacate', 'Chipotle', 'Queso fresco'],
  ),
  Producto(
    id: 'consome_res',
    categoriaId: 'sopas',
    nombre: 'Consomé de Res',
    nombreCompleto: 'Consomé de Res',
    descripcionCorta: 'Res cocida a fuego lento, verduras frescas, cilantro',
    descripcion:
        'Caldo reconfortante de res cocida a fuego lento con verduras frescas.',
    precio: 34900,
    stock: 15,
    ingredientes: ['Carne de res', 'Verduras', 'Cilantro'],
  ),

  // ───────────── MARISCOS ─────────────
  Producto(
    id: 'camarones_ajillo',
    categoriaId: 'mariscos',
    nombre: 'Camarones al Ajillo',
    nombreCompleto: 'Camarones al Ajillo',
    descripcionCorta:
        'Camarones jumbo, ajo dorado, mantequilla, hierbas frescas',
    descripcion:
        'Del mar a tu mesa. Camarones jumbo salteados en mantequilla con ajo dorado y hierbas.',
    precio: 68900,
    stock: 10,
    ingredientes: [
      'Camarones jumbo',
      'Ajo dorado',
      'Mantequilla',
      'Perejil',
      'Limón'
    ],
  ),
  Producto(
    id: 'ceviche_mixto',
    categoriaId: 'mariscos',
    nombre: 'Ceviche Mixto',
    nombreCompleto: 'Ceviche Mixto',
    descripcionCorta:
        'Pescado, camarón, pulpo, limón fresco, cilantro, cebolla',
    descripcion:
        'Pescado, camarón y pulpo marinados en limón fresco con cebolla morada y cilantro.',
    precio: 58900,
    stock: 10,
    ingredientes: ['Pescado', 'Camarón', 'Pulpo', 'Limón', 'Cilantro'],
  ),
  Producto(
    id: 'filete_pescado',
    categoriaId: 'mariscos',
    nombre: 'Filete de Pescado',
    nombreCompleto: 'Filete de Pescado',
    descripcionCorta: 'Robalo a la plancha, vegetales asados, salsa verde',
    descripcion:
        'Robalo fresco a la plancha acompañado de vegetales asados y salsa verde.',
    precio: 72900,
    stock: 0,
    ingredientes: ['Robalo', 'Vegetales asados', 'Salsa verde'],
  ),
  Producto(
    id: 'arroz_mariscos',
    categoriaId: 'mariscos',
    nombre: 'Arroz con Mariscos',
    nombreCompleto: 'Arroz con Mariscos',
    descripcionCorta:
        'Arroz caldoso, camarones, mejillones, calamares, azafrán',
    descripcion:
        'Arroz caldoso con lo mejor del mar: camarones, mejillones y calamares al azafrán.',
    precio: 64900,
    stock: 10,
    ingredientes: ['Arroz', 'Camarones', 'Mejillones', 'Calamares', 'Azafrán'],
  ),

  // ───────────── TACOS ─────────────
  Producto(
    id: 'tacos_pastor',
    categoriaId: 'tacos',
    nombre: 'Tacos al Pastor',
    nombreCompleto: 'Tacos al Pastor',
    descripcionCorta: 'Cerdo marinado al achiote, piña, cebolla, cilantro fresco',
    descripcion:
        'El sabor auténtico del trompo. Cerdo marinado al achiote con piña asada y cilantro fresco.',
    precio: 32900,
    stock: 20,
    ingredientes: [
      'Cerdo marinado',
      'Piña asada',
      'Cebolla',
      'Cilantro',
      'Salsa verde'
    ],
  ),
  Producto(
    id: 'tacos_carnitas',
    categoriaId: 'tacos',
    nombre: 'Tacos de Carnitas',
    nombreCompleto: 'Tacos de Carnitas',
    descripcionCorta: 'Cerdo confitado, salsa verde taquera, cebolla curtida',
    descripcion:
        'Cerdo confitado lentamente, servido con salsa verde taquera y cebolla curtida.',
    precio: 34900,
    stock: 20,
    ingredientes: ['Cerdo confitado', 'Salsa verde', 'Cebolla curtida'],
  ),
  Producto(
    id: 'tacos_birria',
    categoriaId: 'tacos',
    nombre: 'Tacos de Birria',
    nombreCompleto: 'Tacos de Birria',
    descripcionCorta: 'Res estofada en chile, consomé, cebolla, cilantro',
    descripcion:
        'Res estofada en chiles secos, acompañada de su consomé para mojar.',
    precio: 38900,
    stock: 0,
    ingredientes: ['Res estofada', 'Consomé', 'Cebolla', 'Cilantro'],
  ),
  Producto(
    id: 'tacos_camaron',
    categoriaId: 'tacos',
    nombre: 'Tacos de Camarón',
    nombreCompleto: 'Tacos de Camarón',
    descripcionCorta: 'Camarones empanizados, chipotle cremoso, repollo, limón',
    descripcion:
        'Camarones empanizados crujientes con chipotle cremoso y repollo fresco.',
    precio: 42900,
    stock: 20,
    ingredientes: ['Camarones', 'Chipotle cremoso', 'Repollo', 'Limón'],
  ),

  // ───────────── SUSHI ─────────────
  Producto(
    id: 'california_roll',
    categoriaId: 'sushi',
    nombre: 'California Roll',
    nombreCompleto: 'California Roll',
    descripcionCorta: 'Cangrejo, aguacate cremoso, pepino fresco, ajonjolí tostado',
    descripcion:
        'El clásico japonés reinventado. Arroz de sushi con cangrejo, aguacate cremoso y pepino fresco.',
    precio: 48900,
    stock: 12,
    ingredientes: [
      'Cangrejo',
      'Aguacate',
      'Pepino',
      'Arroz de sushi',
      'Ajonjolí'
    ],
  ),
  Producto(
    id: 'tempura_roll',
    categoriaId: 'sushi',
    nombre: 'Tempura Roll',
    nombreCompleto: 'Tempura Roll',
    descripcionCorta: 'Camarón tempura crujiente, aguacate, salsa de anguila',
    descripcion:
        'Camarón tempura crujiente envuelto con aguacate y bañado en salsa de anguila.',
    precio: 54900,
    stock: 12,
    ingredientes: ['Camarón tempura', 'Aguacate', 'Salsa de anguila'],
  ),
  Producto(
    id: 'sashimi_mixto',
    categoriaId: 'sushi',
    nombre: 'Sashimi Mixto',
    nombreCompleto: 'Sashimi Mixto',
    descripcionCorta: 'Salmón, atún rojo, pez blanco, jengibre, wasabi fresco',
    descripcion:
        'Cortes frescos de salmón, atún rojo y pez blanco con jengibre y wasabi.',
    precio: 68900,
    stock: 0,
    ingredientes: ['Salmón', 'Atún rojo', 'Pez blanco', 'Jengibre', 'Wasabi'],
  ),
  Producto(
    id: 'dragon_roll',
    categoriaId: 'sushi',
    nombre: 'Dragon Roll',
    nombreCompleto: 'Dragon Roll',
    descripcionCorta: 'Anguila glaseada, aguacate, camarón tempura, tobiko',
    descripcion:
        'Anguila glaseada sobre camarón tempura y aguacate, coronado con tobiko.',
    precio: 58900,
    stock: 12,
    ingredientes: ['Anguila', 'Aguacate', 'Camarón tempura', 'Tobiko'],
  ),
];
