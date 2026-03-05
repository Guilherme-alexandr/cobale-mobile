import 'package:flutter/material.dart';

class CardSucessoPagamento extends StatelessWidget {
  final double valor;
  final String metodoPagamento;
  final int? parcelaAtual;
  final int? totalParcelas;
  final VoidCallback aoConfirmar;

  const CardSucessoPagamento({
    Key? key,
    required this.valor,
    required this.metodoPagamento,
    this.parcelaAtual,
    this.totalParcelas,
    required this.aoConfirmar,
  }) : super(key: key);

  String _getTitulo() {
    switch (metodoPagamento) {
      case 'pix':
        return 'PIX Processado!';
      case 'boleto':
        return 'Boleto Gerado!';
      default:
        return 'Pagamento Confirmado!';
    }
  }

  String _getMensagem() {
    String valorFormatado = 'R\$ ${valor.toStringAsFixed(2)}';

    if (parcelaAtual != null && totalParcelas != null) {
      switch (metodoPagamento) {
        case 'pix':
          return 'Pagamento da parcela $parcelaAtual/$totalParcelas de $valorFormatado via PIX foi processado instantaneamente.';
        case 'boleto':
          return 'Boleto da parcela $parcelaAtual/$totalParcelas de $valorFormatado gerado. O pagamento será confirmado em até 3 dias úteis.';
        default:
          return 'Pagamento da parcela $parcelaAtual/$totalParcelas de $valorFormatado confirmado.';
      }
    } else {
      switch (metodoPagamento) {
        case 'pix':
          return 'Seu pagamento de $valorFormatado via PIX foi processado instantaneamente.';
        case 'boleto':
          return 'Boleto de $valorFormatado gerado. O pagamento será confirmado em até 3 dias úteis.';
        default:
          return 'Seu pagamento de $valorFormatado foi confirmado.';
      }
    }
  }

  String _getInstrucao() {
    switch (metodoPagamento) {
      case 'pix':
        return 'O PIX já foi processado e o crédito é instantâneo.';
      case 'boleto':
        return 'Aguardando compensação do boleto (até 3 dias úteis).';
      default:
        return 'Redirecionando...';
    }
  }

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
                    decoration: BoxDecoration(
                      color: metodoPagamento == 'boleto'
                          ? Colors.blue.shade50
                          : const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      metodoPagamento == 'boleto'
                          ? Icons.receipt
                          : Icons.check_circle,
                      size: 64,
                      color: metodoPagamento == 'boleto'
                          ? Colors.blue
                          : const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _getTitulo(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getMensagem(),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: metodoPagamento == 'boleto'
                          ? Colors.blue.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getInstrucao(),
                      style: TextStyle(
                        fontSize: 14,
                        color: metodoPagamento == 'boleto'
                            ? Colors.blue.shade700
                            : Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
