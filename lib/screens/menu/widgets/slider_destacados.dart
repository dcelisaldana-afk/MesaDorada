import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/database/datos_iniciales.dart';
import '../../../data/database/imagenes.dart';
import '../../../data/models/slide_destacado.dart';
import '../../../widgets/imagen_plato.dart';

/// Slider automático de platos destacados: rota cada 5 segundos
/// deslizando hacia la derecha (el siguiente entra desde la derecha).
class SliderDestacados extends StatefulWidget {
  const SliderDestacados({super.key});

  @override
  State<SliderDestacados> createState() => _SliderDestacadosState();
}

class _SliderDestacadosState extends State<SliderDestacados> {
  // Página inicial alta para poder avanzar "infinitamente".
  static const int _paginaInicial = 1000;
  final List<SlideDestacado> _slides = slidesDestacados;
  late final PageController _controlador;
  Timer? _temporizador;
  int _actual = 0;

  @override
  void initState() {
    super.initState();
    _controlador = PageController(
      viewportFraction: 0.86,
      initialPage: _paginaInicial * _slides.length,
    );
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _temporizador?.cancel();
    _temporizador = Timer.periodic(AppConfig.intervaloSlider, (_) {
      if (!_controlador.hasClients) return;
      _controlador.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: NotificationListener<ScrollStartNotification>(
            // Si el usuario desliza manualmente, se reinicia el conteo.
            onNotification: (n) {
              if (n.dragDetails != null) _iniciarTemporizador();
              return false;
            },
            child: PageView.builder(
              controller: _controlador,
              onPageChanged: (i) =>
                  setState(() => _actual = i % _slides.length),
              itemBuilder: (context, i) {
                final slide = _slides[i % _slides.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _TarjetaSlide(slide: slide),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (i) {
            final activo = i == _actual;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: activo ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: activo ? AppColors.primario : AppColors.borde,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _TarjetaSlide extends StatelessWidget {
  final SlideDestacado slide;

  const _TarjetaSlide({required this.slide});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.producto,
          arguments: slide.productoId),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImagenPlato(
              rutas: [
                slide.imagen,
                'assets/images/productos/${slide.productoId}.jpg',
              ],
              url: urlUnsplash(fotosProductos[slide.productoId], ancho: 800),
              categoriaId: slide.categoriaId,
              tamanoIcono: 64,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xB3000000), Color(0x00000000), Color(0x8C000000)],
                  stops: [0, 0.5, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slide.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    slide.subtitulo,
                    style: const TextStyle(color: Color(0xE6FFFFFF), fontSize: 13),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primario,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  AppStrings.especial,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
