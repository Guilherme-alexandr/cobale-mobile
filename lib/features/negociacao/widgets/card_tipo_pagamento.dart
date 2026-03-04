import 'package:flutter/material.dart';

class CardTipoPagamento extends StatelessWidget {
  final String tipoPagamento;
  final double valorDebito;
  final Function(String) aoAlterar;

  const CardTipoPagamento({
    Key? key,
    required this.tipoPagamento,
    required this.valorDebito,
    required this.aoAlterar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Forma de Pagamento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildOpcaoRadio(
              valor: 'dinheiro',
              titulo: 'À Vista',
              subtitulo: 'Pagamento integral',
              preco: 'R\$ ${valorDebito.toStringAsFixed(2)}',
              icone: Icons.payments,
            ),
            const SizedBox(height: 12),
            _buildOpcaoRadio(
              valor: 'parcelamento',
              titulo: 'Parcelado',
              subtitulo: 'Em até 12 vezes com juros',
              icone: Icons.calendar_month,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcaoRadio({
    required String valor,
    required String titulo,
    required String subtitulo,
    String? preco,
    required IconData icone,
  }) {
    final isSelecionado = tipoPagamento == valor;

    return GestureDetector(
      onTap: () => aoAlterar(valor),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelecionado ? Colors.blue : Colors.grey.shade300,
            width: isSelecionado ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelecionado ? Colors.blue.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Icon(
              icone,
              color: isSelecionado ? Colors.blue : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitulo,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (preco != null)
              Text(
                preco,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4CAF50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
