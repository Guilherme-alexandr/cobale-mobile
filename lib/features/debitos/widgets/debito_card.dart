import 'package:flutter/material.dart';
import '../models/debito_model.dart';
import '../pages/debito_detalhe_page.dart';

class DebitoCard extends StatelessWidget {
  final Debito debito;

  const DebitoCard({super.key, required this.debito});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(debito.descricao),
        subtitle: Text(
          'Vencimento: ${debito.vencimento.day}/${debito.vencimento.month}/${debito.vencimento.year}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('R\$ ${debito.valor.toStringAsFixed(2)}'),
            Text(
              debito.pago ? 'Pago' : 'Em aberto',
              style: TextStyle(color: debito.pago ? Colors.green : Colors.red),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DebitoDetalhePage(debito: debito),
            ),
          );
        },
      ),
    );
  }
}
