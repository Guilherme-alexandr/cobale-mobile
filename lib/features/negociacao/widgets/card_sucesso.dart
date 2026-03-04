import 'package:flutter/material.dart';

class CardSucesso extends StatelessWidget {
  final bool pagamentoAVista;
  final double valorDebito;
  final int parcelas;
  final double valorParcela;
  final VoidCallback aoConfirmar;

  const CardSucesso({
    Key? key,
    required this.pagamentoAVista,
    required this.valorDebito,
    required this.parcelas,
    required this.valorParcela,
    required this.aoConfirmar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        aoConfirmar();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Acordo Confirmado!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pagamentoAVista
                        ? 'Pagamento à vista de R\$ ${valorDebito.toStringAsFixed(2)} confirmado.'
                        : 'Parcelamento em ${parcelas}x de R\$ ${valorParcela.toStringAsFixed(2)} confirmado.',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Redirecionando...',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
