import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class AcoesRapidas extends StatelessWidget {
  const AcoesRapidas({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.debitos);
          },
          child: const Text('Ver Débitos'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // FUTURO: navegar para negociação
          },
          child: const Text('Negociar'),
        ),
      ],
    );
  }
}
