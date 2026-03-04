import 'package:flutter/material.dart';

class CardSucessoPagamento extends StatelessWidget {
  final double valor;
  final int? parcelaAtual;
  final int? totalParcelas;
  final VoidCallback aoConfirmar;

  const CardSucessoPagamento({
    Key? key,
    required this.valor,
    this.parcelaAtual,
    this.totalParcelas,
    required this.aoConfirmar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Aguarda 2 segundos e volta
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
                    'Pagamento Confirmado!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getMensagem(),
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

  String _getMensagem() {
    if (parcelaAtual != null && totalParcelas != null) {
      return 'Pagamento da parcela $parcelaAtual/$totalParcelas de R\$ ${valor.toStringAsFixed(2)} foi processado com sucesso.';
    }
    return 'Seu pagamento de R\$ ${valor.toStringAsFixed(2)} foi processado com sucesso.';
  }
}
