/// Fotos de los platos (Unsplash, licencia libre de uso).
///
/// La app las descarga de internet la primera vez. Si quieren que funcionen
/// sin internet, ejecuten una vez:
///     dart run tool/descargar_imagenes.dart
/// que las guarda en assets/images/ (la app usa primero la foto local).
///
/// Para cambiar una foto: reemplacen el código "photo-..." del plato, o
/// pongan su propia imagen en assets/images/productos/<id>.jpg.
const Map<String, String> fotosProductos = {
  // Hamburguesas
  'triple_carne': 'photo-1572802419224-296b0aeee0d9',
  'doble_queso': 'photo-1607013251379-e6eecfffe234',
  'bbq_especial': 'photo-1553979459-d2229ba7433b',
  'clasica': 'photo-1568901346375-23c9450c58cd',
  // Pizzas
  'pizza_peperoni': 'photo-1534308983496-4fabb1a015ee',
  'pizza_margarita': 'photo-1574071318508-1cdbab80d002',
  'pizza_hawaiana': 'photo-1562835155-a7c2a225e97d',
  'pizza_4_quesos': 'photo-1513104890138-7c749659a591',
  // Ensaladas
  'ensalada_cesar': 'photo-1746211108786-ca20c8f80ecd',
  'ensalada_griega': 'photo-1599021419847-d8a7a6aba5b4',
  'ensalada_tropical': 'photo-1564929360162-73cd686db4a1',
  'ensalada_chef': 'photo-1546793665-c74683f339c1',
  // Pastas
  'pasta_trufada': 'photo-1597692493647-35763cb92183',
  'fettuccine_alfredo': 'photo-1645112411341-6c4fd023714a',
  'lasana_clasica': 'photo-1709429790175-b02bb1b19207',
  'spaghetti_bolognesa': 'photo-1622973536968-3ead9e780960',
  // Postres
  'tiramisu': 'photo-1571877227200-a0d98ea607e9',
  'brownie_helado': 'photo-1606884285898-277317a7bf12',
  'cheesecake': 'photo-1524351199678-941a58a3df50',
  'flan_caramelo': 'photo-1653988354010-39637252a2db',
  // Bebidas
  'limonada_natural': 'photo-1523677011781-c91d1bbe2f9e',
  'jugo_mango': 'photo-1623065422902-30a2d299bbe4',
  'smoothie_fresa': 'photo-1579954115545-a95591f28bfc',
  'malteada_chocolate': 'photo-1572490122747-3968b75cc699',
  // Sopas
  'sopa_tortilla': 'photo-1619151578119-b2f65ec6ebd8',
  'crema_tomate': 'photo-1547592166-23ac45744acd',
  'sopa_azteca': 'photo-1644753787064-9f2846d6c995',
  'consome_res': 'photo-1608500218987-0f2b3be34b47',
  // Mariscos
  'camarones_ajillo': 'photo-1625943553852-781c6dd46faa',
  'ceviche_mixto': 'photo-1535399831218-d5bd36d1a6b3',
  'filete_pescado': 'photo-1519708227418-c8fd9a32b7a2',
  'arroz_mariscos': 'photo-1534080564583-6be75777b70a',
  // Tacos
  'tacos_pastor': 'photo-1599974579688-8dbdd335c77f',
  'tacos_carnitas': 'photo-1565299585323-38d6b0865b47',
  'tacos_birria': 'photo-1613514785940-daed07799d9b',
  'tacos_camaron': 'photo-1545093149-618ce3bcf49d',
  // Sushi
  'california_roll': 'photo-1559410545-0bdcd187e0a6',
  'tempura_roll': 'photo-1579871494447-9811cf80d66c',
  'sashimi_mixto': 'photo-1563612116625-3012372fccce',
  'dragon_roll': 'photo-1579584425555-c3ce17fd4351',
};

const Map<String, String> fotosCategorias = {
  'hamburguesas': 'photo-1586190848861-99aa4a171e90',
  'pizzas': 'photo-1565299624946-b28f40a0ae38',
  'ensaladas': 'photo-1607532941433-304659e8198a',
  'pastas': 'photo-1551892374-ecf8754cf8b0',
  'postres': 'photo-1624353365286-3f8d62daad51',
  'bebidas': 'photo-1623084921164-4a8c5c37a912',
  'sopas': 'photo-1620791144170-8a443bf37a33',
  'mariscos': 'photo-1579783411296-c908953b2dcd',
  'tacos': 'photo-1624300629298-e9de39c13be5',
  'sushi': 'photo-1611143669185-af224c5e3252',
};

/// Arma la dirección de la foto con el ancho pedido (en píxeles).
String? urlUnsplash(String? foto, {int ancho = 600}) => foto == null
    ? null
    : 'https://images.unsplash.com/$foto?auto=format&fit=crop&w=$ancho&q=80';
