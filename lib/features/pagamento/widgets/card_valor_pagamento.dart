import 'package:flutter/material.dart';

class CardValorPagamento extends StatelessWidget {
  final double valor;
  final int? parcelaAtual;
  final int? totalParcelas;

  const CardValorPagamento({
    Key? key,
    required this.valor,
    this.parcelaAtual,
    this.totalParcelas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parcelaAtual != null ? 'Valor da parcela' : 'Valor a pagar',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${valor.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (parcelaAtual != null && totalParcelas != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Parcela $parcelaAtual de $totalParcelas',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
