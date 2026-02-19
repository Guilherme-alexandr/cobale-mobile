import 'package:flutter/material.dart';
import '../models/debito_model.dart';
import '../../negociacao/pages/negociacao_page.dart';

class DebitoDetalhePage extends StatelessWidget {
  final Debito debito;

  const DebitoDetalhePage({super.key, required this.debito});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do Débito')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              debito.descricao,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Valor: R\$ ${debito.valor.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              'Vencimento: ${debito.vencimento.day}/${debito.vencimento.month}/${debito.vencimento.year}',
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${debito.pago ? "Pago" : "Em aberto"}',
              style: TextStyle(
                color: debito.pago ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            if (!debito.pago)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NegociacaoPage(debito: debito),
                      ),
                    );
                  },
                  child: const Text('Negociar Débito'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
