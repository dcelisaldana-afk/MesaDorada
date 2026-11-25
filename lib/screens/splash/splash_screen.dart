import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/logo_restaurante.dart';
import 'widgets/boton_ingresar.dart';
import 'widgets/enlace_resena.dart';

/// 1. Pantalla de Inicio (Splash).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: _contenido(context),
    );
  }

  Widget _contenido(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primario,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              const Center(child: LogoRestaurante()),
              const SizedBox(height: 28),
              const Text(
                AppStrings.nombreRestaurante,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                AppStrings.eslogan,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 15),
              ),
              const Spacer(flex: 4),
              BotonIngresar(
                alPresionar: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.menu),
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerRight,
                child: EnlaceResena(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
