import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../widgets/resumo_card.dart';
import '../widgets/acoes_rapidas.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();

    return Scaffold(
      appBar: AppBar(title: const Text('CobAle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${controller.saudacao}, Guilherme',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ResumoCard(
              total: controller.totalEmAberto,
              quantidade: controller.quantidadeDebitos,
            ),
            const SizedBox(height: 20),
            const AcoesRapidas(),
          ],
        ),
      ),
    );
  }
}
