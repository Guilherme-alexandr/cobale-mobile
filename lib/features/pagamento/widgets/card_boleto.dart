import 'package:flutter/material.dart';
import '../controllers/pagamento_controller.dart';

class CardBoleto extends StatelessWidget {
  final DateTime vencimento;
  final VoidCallback aoCopiarCodigo;
  final VoidCallback aoImprimir;
  final VoidCallback aoConfirmarPagamento;

  const CardBoleto({
    Key? key,
    required this.vencimento,
    required this.aoCopiarCodigo,
    required this.aoImprimir,
    required this.aoConfirmarPagamento,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.qr_code_2, size: 64, color: Colors.blue.shade700),
                  const SizedBox(height: 8),
                  const Text(
                    'Código de Barras',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    PagamentoController.boletoCode,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Código copiado!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 1),
                        ),
                      );
                      aoCopiarCodigo();
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copiar Código'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Boleto gerado para impressão!'),
                          backgroundColor: Colors.blue,
                          duration: Duration(seconds: 1),
                        ),
                      );
                      aoImprimir();
                    },
                    icon: const Icon(Icons.print, size: 16),
                    label: const Text('Imprimir'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                border: Border.all(color: Colors.yellow.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Color(0xFFB45309),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Vencimento: ${vencimento.day}/${vencimento.month}/${vencimento.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB45309),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'O pagamento pode levar até 3 dias úteis para ser confirmado',
                    style: TextStyle(fontSize: 10, color: Color(0xFFB45309)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar pagamento?'),
                      content: const Text(
                        'O pagamento via boleto pode levar até 3 dias úteis para ser compensado. '
                        'Deseja confirmar que já realizou o pagamento?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            aoConfirmarPagamento(); // ✅ AGORA USA O CALLBACK
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Sim, já paguei'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Já realizei o pagamento',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
