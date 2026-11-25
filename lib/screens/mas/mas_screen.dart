import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../services/notificacion_service.dart';
import '../../widgets/barra_superior.dart';
import '../../widgets/dialogo_resena.dart';
import '../../widgets/logo_restaurante.dart';
import '../../widgets/mensajes.dart';

/// Pestaña "Más": cómo funciona el autoservicio, notificaciones, reseñas
/// e información de la app (reemplaza al antiguo menú lateral ☰).
class MasScreen extends StatelessWidget {
  const MasScreen({super.key});

  Future<void> _activarNotificaciones(BuildContext context) async {
    final servicio = NotificacionService.instancia;
    final ok = await servicio.solicitarPermiso();
    if (ok) await servicio.enviarPrueba();
    if (!context.mounted) return;
    mostrarMensaje(
      context,
      ok
          ? 'Notificaciones activadas'
          : 'Activa las notificaciones en los ajustes del teléfono',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(titulo: AppStrings.mas, mostrarAtras: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          // Encabezado
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primario,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                LogoRestaurante(tamano: 64),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.nombreRestaurante,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        AppStrings.eslogan,
                        style:
                            TextStyle(color: Color(0xDDFFFFFF), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Cómo funciona el autoservicio
          const _Tarjeta(
            titulo: '¿Cómo funciona?',
            child: Column(
              children: [
                _Paso(
                  numero: '1',
                  texto: 'Elige tus platos desde el menú y agrégalos al carrito.',
                ),
                _Paso(
                  numero: '2',
                  texto:
                      'Realiza el pedido y recibe tu número de turno.',
                ),
                _Paso(
                  numero: '3',
                  texto:
                      'Te llegará una notificación cuando esté listo: recógelo en la barra.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _Tarjeta(
            child: Column(
              children: [
                _Opcion(
                  icono: Icons.notifications_active_outlined,
                  texto: 'Activar notificaciones',
                  alTocar: () => _activarNotificaciones(context),
                ),
                const Divider(height: 1, color: AppColors.borde),
                _Opcion(
                  icono: Icons.star_outline_rounded,
                  texto: AppStrings.resenanos,
                  alTocar: () => mostrarDialogoResena(context),
                ),
                const Divider(height: 1, color: AppColors.borde),
                _Opcion(
                  icono: Icons.admin_panel_settings_outlined,
                  texto: 'Acceso cocina (administrador)',
                  alTocar: () =>
                      Navigator.pushNamed(context, AppRoutes.loginCocina),
                ),
                const Divider(height: 1, color: AppColors.borde),
                _Opcion(
                  icono: Icons.info_outline_rounded,
                  texto: 'Acerca de la app',
                  alTocar: () => showAboutDialog(
                    context: context,
                    applicationName: AppStrings.nombreRestaurante,
                    applicationVersion: '1.0',
                    applicationLegalese:
                        'Aplicaciones Móviles · Grupo B191\nUnidades Tecnológicas de Santander',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  final String? titulo;
  final Widget child;

  const _Tarjeta({this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, titulo == null ? 4 : 16, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titulo != null) ...[
            Text(
              titulo!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _Paso extends StatelessWidget {
  final String numero;
  final String texto;

  const _Paso({required this.numero, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primario,
              shape: BoxShape.circle,
            ),
            child: Text(
              numero,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                texto,
                style: const TextStyle(fontSize: 14, color: AppColors.texto),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback alTocar;

  const _Opcion({
    required this.icono,
    required this.texto,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icono, color: AppColors.primario),
      title: Text(
        texto,
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: AppColors.texto),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textoSecundario),
      onTap: alTocar,
    );
  }
}
