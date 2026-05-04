// lib/features/detalhes/widgets/action_buttons.dart

import 'package:flutter/material.dart';
import '../../negociacao/pages/negociacao_page.dart';
import '../../pagamento/pages/pagamento_page.dart';
import '../models/bill_model.dart';

class ActionButtons extends StatelessWidget {
  final Bill bill;
  final VoidCallback onPayment;
  final VoidCallback onNegotiation;
  final VoidCallback? onDownloadDocument;

  const ActionButtons({
    super.key,
    required this.bill,
    required this.onPayment,
    required this.onNegotiation,
    this.onDownloadDocument,
  });

  @override
  Widget build(BuildContext context) {
    // Padronizamos o status para evitar erro de maiúsculas/minúsculas
    final status = bill.status.toLowerCase();

    debugPrint('🔍 ActionButtons - Status processado: $status');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // ===========================================================
          // 1. BOTÃO DE NEGOCIAR (Para status 'pendente' ou 'pending')
          // ===========================================================
          if (status == 'pendente' || status == 'pending')
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NegociacaoPage(
                          idCobranca: bill.id,
                          valorDebito: bill.value,
                          nomeCliente:
                              bill.client ?? 'Cliente não identificado',
                          aoVoltar: () => Navigator.pop(context),
                          aoConfirmar: () {
                            onNegotiation();
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.handshake),
                  label: const Text('Negociar Débito'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

          // ===========================================================
          // 2. BOTÃO DE PAGAR (Para 'em andamento' ou 'in_progress')
          // ===========================================================
          if (status == 'em andamento' || status == 'in_progress')
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PagamentoPage(
                          aoVoltar: () => Navigator.pop(context),
                          aoConfirmar: () {
                            onPayment();
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                          idCobranca: bill.id,
                          // Se for contrato novo (sem parcelas ainda), enviamos 1/1
                          parcelaAtual: bill.installment?.current ?? 1,
                          totalParcelas: bill.installment?.total ?? 1,
                          valorPersonalizado:
                              bill.installment?.value ?? bill.value,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.credit_card),
                  label: Text(
                    bill.installment != null
                        ? 'Pagar Parcela ${bill.installment!.current}/${bill.installment!.total}'
                        : 'Realizar Pagamento',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

          // ===========================================================
          // 3. BOTÃO DE DOWNLOAD (Para 'completed' ou 'finalizada')
          // ===========================================================
          if (status == 'completed' ||
              status == 'finalizada' ||
              status == 'concluido')
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed:
                      onDownloadDocument ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Download do documento - Em breve'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                  icon: const Icon(Icons.file_download),
                  label: const Text('Baixar Documento'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

          // Botões de Compartilhar e PDF (Sempre visíveis)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _showSnack(context, 'Compartilhar'),
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                    style: _outlinedStyle(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _showSnack(context, 'Baixar PDF'),
                    icon: const Icon(Icons.download),
                    label: const Text('Baixar PDF'),
                    style: _outlinedStyle(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helpers para manter o código limpo
  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  ButtonStyle _outlinedStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
