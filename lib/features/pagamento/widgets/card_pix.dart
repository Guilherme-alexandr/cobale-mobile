import 'package:flutter/material.dart';
import '../controllers/pagamento_controller.dart';

class CardPix extends StatelessWidget {
  final VoidCallback aoCopiarCodigo;
  final VoidCallback aoConfirmarPagamento; // ✅ ADICIONADO

  const CardPix({
    Key? key,
    required this.aoCopiarCodigo,
    required this.aoConfirmarPagamento, // ✅ ADICIONADO
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
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.qr_code, size: 100, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Escaneie o QR Code com seu app de pagamento',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              'ou copie o código PIX abaixo',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    PagamentoController.pixCode,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Código PIX copiado!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                        aoCopiarCodigo();
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copiar Código PIX'),
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
            ),

            const SizedBox(height: 16),

            const Text(
              'Pagamento instantâneo • Disponível 24h',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
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
                        'Você já realizou o pagamento via PIX?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Não'),
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
