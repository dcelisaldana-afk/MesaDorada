import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/dialogo_resena.dart';

/// Texto "Reséñanos ☆☆☆☆☆" de la esquina inferior derecha del splash.
class EnlaceResena extends StatelessWidget {
  const EnlaceResena({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => mostrarDialogoResena(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              AppStrings.resenanos,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            ...List.generate(
              5,
              (_) => const Icon(Icons.star_outline_rounded,
                  size: 16, color: AppColors.estrella),
            ),
          ],
        ),
      ),
    );
  }
}
