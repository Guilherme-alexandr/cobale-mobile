import 'package:flutter/material.dart';

import '../controllers/debitos_controller.dart';
import '../widgets/debito_card.dart';

class DebitosPage extends StatelessWidget {
  const DebitosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DebitosController();
    final debitos = controller.listarDebitos();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Débitos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: debitos.length,
        itemBuilder: (context, index) {
          return DebitoCard(debito: debitos[index]);
        },
      ),
    );
  }
}
