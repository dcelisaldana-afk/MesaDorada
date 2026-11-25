// Pruebas unitarias de la lógica (no requieren emulador):
//   flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:la_mesa_dorada/core/utils/formato_moneda.dart';
import 'package:la_mesa_dorada/core/utils/politica_acceso.dart';
import 'package:la_mesa_dorada/core/utils/seguridad.dart';
import 'package:la_mesa_dorada/data/models/producto.dart';
import 'package:la_mesa_dorada/providers/catalogo_provider.dart';
import 'package:la_mesa_dorada/data/database/datos_iniciales.dart';
import 'package:la_mesa_dorada/data/models/codigo_promocional.dart';
import 'package:la_mesa_dorada/data/models/pedido.dart';
import 'package:la_mesa_dorada/providers/carrito_provider.dart';

void main() {
  group('formatoPesos', () {
    test('agrega separador de miles', () {
      expect(formatoPesos(45900), r'$45.900');
      expect(formatoPesos(160700), r'$160.700');
      expect(formatoPesos(9900), r'$9.900');
      expect(formatoPesos(1250000), r'$1.250.000');
      expect(formatoPesos(0), r'$0');
    });
  });

  group('CarritoProvider', () {
    final tripleCarne =
        productosIniciales.firstWhere((p) => p.id == 'triple_carne');
    final bbq = productosIniciales.firstWhere((p) => p.id == 'bbq_especial');

    test('agrega productos y calcula el total', () {
      final carrito = CarritoProvider();
      carrito.agregar(tripleCarne, cantidad: 2);
      expect(carrito.cantidadTotal, 2);
      expect(carrito.subtotal, 91800);
      expect(carrito.total, 91800);
    });

    test('no permite agregar productos agotados (SOLD OUT)', () {
      final carrito = CarritoProvider();
      expect(carrito.agregar(bbq), ResultadoAgregar.agotado);
      expect(carrito.estaVacio, isTrue);
    });

    test('no supera el stock disponible', () {
      final carrito = CarritoProvider();
      final r = carrito.agregar(tripleCarne, cantidad: tripleCarne.stock + 5);
      expect(r, ResultadoAgregar.limiteStock);
      expect(carrito.cantidadDe(tripleCarne.id), tripleCarne.stock);
    });

    test('aplica código promocional', () {
      final carrito = CarritoProvider();
      carrito.agregar(tripleCarne); // 45.900
      carrito.aplicarCodigo(const CodigoPromocional(
          codigo: 'MESA10', tipo: 'porcentaje', valor: 10));
      expect(carrito.descuento, 4590);
      expect(carrito.total, 41310);
    });

    test('disminuir a cero elimina el producto', () {
      final carrito = CarritoProvider();
      carrito.agregar(tripleCarne);
      carrito.disminuir(tripleCarne.id);
      expect(carrito.estaVacio, isTrue);
    });
  });

  group('Pedido', () {
    test('los estados avanzan en orden hasta entregado', () {
      expect(EstadoPedido.recibido.siguiente, EstadoPedido.enPreparacion);
      expect(EstadoPedido.enPreparacion.siguiente, EstadoPedido.listo);
      expect(EstadoPedido.listo.siguiente, EstadoPedido.entregado);
      expect(EstadoPedido.entregado.siguiente, isNull);
      expect(EstadoPedido.desdeValor('listo'), EstadoPedido.listo);
      expect(EstadoPedido.desdeValor('desconocido'), EstadoPedido.recibido);
    });

    test('se guarda y se lee con su estado y turno', () {
      final pedido = Pedido(
        id: 1,
        fecha: DateTime(2026, 11, 24, 12),
        subtotal: 1,
        descuento: 0,
        envio: 0,
        total: 1,
        codigoPromocional: null,
        tipoEntrega: Pedido.tipoComerAqui,
        items: const [],
        estado: EstadoPedido.listo,
      );
      final leido = Pedido.desdeMapa(pedido.aMapa(), const []);
      expect(leido.estado, EstadoPedido.listo);
      expect(leido.codigo, 'Turno 001');
    });
  });

  group('Disponibilidad de productos', () {
    final base = productosIniciales.firstWhere((p) => p.id == 'triple_carne');

    test('con stock y habilitado se puede pedir', () {
      expect(base.disponible, isTrue);
    });

    test('la cocina puede marcarlo como no disponible aunque tenga stock', () {
      final pausado = base.copiarCon(habilitado: false);
      expect(pausado.stock, greaterThan(0));
      expect(pausado.disponible, isFalse);
    });

    test('stock bajo a partir de ${Producto.limiteStockBajo} unidades', () {
      expect(base.copiarCon(stock: 5).stockBajo, isTrue);
      expect(base.copiarCon(stock: 6).stockBajo, isFalse);
    });

    test('un producto desactivado no aparece en el menú', () {
      expect(base.copiarCon(activo: false).disponible, isFalse);
    });

    test('genera ids sin tildes ni espacios', () {
      final catalogo = CatalogoProvider();
      expect(catalogo.generarId('Pizza Napolitana'), 'pizza_napolitana');
      expect(catalogo.generarId('Café con Leche!'), 'cafe_con_leche');
    });
  });

  group('Seguridad del panel de cocina', () {
    test('la contraseña no se guarda en texto plano y se verifica', () {
      final sal = Seguridad.generarSal();
      final hash = Seguridad.hashContrasena('Cocina2026', sal);
      expect(hash.contains('Cocina2026'), isFalse);
      expect(Seguridad.verificar('Cocina2026', sal, hash), isTrue);
      expect(Seguridad.verificar('otra', sal, hash), isFalse);
    });

    test('misma contraseña con distinta sal da hashes distintos', () {
      expect(Seguridad.hashContrasena('abc12345', 's1'),
          isNot(Seguridad.hashContrasena('abc12345', 's2')));
    });

    test('valida la contraseña nueva', () {
      expect(Seguridad.validarContrasenaNueva('corta1'), isNotNull);
      expect(Seguridad.validarContrasenaNueva('sololetras'), isNotNull);
      expect(Seguridad.validarContrasenaNueva('Cocina2027'), isNull);
    });

    test('bloquea tras 5 intentos fallidos durante 5 minutos', () {
      const politica = PoliticaAcceso();
      final ahora = DateTime(2026, 11, 24, 10);
      var intentos = 0;
      ResultadoFallo? r;
      for (var i = 0; i < 4; i++) {
        r = politica.registrarFallo(intentos, ahora);
        intentos = r.intentos;
        expect(r.bloqueo, isFalse);
      }
      expect(r!.intentosRestantes, 1);
      r = politica.registrarFallo(intentos, ahora);
      expect(r.bloqueo, isTrue);
      expect(politica.estaBloqueado(r.bloqueadoHasta,
          ahora.add(const Duration(minutes: 4))), isTrue);
      expect(politica.estaBloqueado(r.bloqueadoHasta,
          ahora.add(const Duration(minutes: 5, seconds: 1))), isFalse);
    });
  });
}
