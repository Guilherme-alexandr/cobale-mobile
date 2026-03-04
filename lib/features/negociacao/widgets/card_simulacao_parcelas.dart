import 'package:flutter/material.dart';

class CardSimulacaoParcelas extends StatelessWidget {
  final int parcelas;
  final double valorDebito;
  final double totalComJuros;
  final double valorParcela;
  final Function(int) aoAlterarParcelas;

  const CardSimulacaoParcelas({
    Key? key,
    required this.parcelas,
    required this.valorDebito,
    required this.totalComJuros,
    required this.valorParcela,
    required this.aoAlterarParcelas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valorJuros = totalComJuros - valorDebito;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calculate, color: Color(0xFF2196F3), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Simulação de Parcelas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Número de parcelas',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: parcelas.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixText: 'parcelas',
                  ),
                  onChanged: (value) {
                    final novoValor = int.tryParse(value) ?? 2;
                    aoAlterarParcelas(novoValor.clamp(2, 12));
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'De 2 a 12 parcelas',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _construirLinhaResumo(
                    'Valor original:',
                    'R\$ ${valorDebito.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _construirLinhaResumo(
                    'Juros (2% ao mês):',
                    '+ R\$ ${valorJuros.toStringAsFixed(2)}',
                    corValor: Colors.red,
                  ),
                  const Divider(height: 16),
                  _construirLinhaResumo(
                    'Total:',
                    'R\$ ${totalComJuros.toStringAsFixed(2)}',
                    negrito: true,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Valor da parcela',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${parcelas}x de R\$ ${valorParcela.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Detalhamento das parcelas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: parcelas,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${index + 1}ª parcela'),
                        Text(
                          'R\$ ${valorParcela.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirLinhaResumo(
    String rotulo,
    String valor, {
    Color corValor = Colors.black87,
    bool negrito = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(rotulo, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Text(
          valor,
          style: TextStyle(
            fontSize: 14,
            fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
            color: corValor,
          ),
        ),
      ],
    );
  }
}
