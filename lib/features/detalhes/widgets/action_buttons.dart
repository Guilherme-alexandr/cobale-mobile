import 'package:flutter/material.dart';
import '../../negociacao/pages/negociacao_page.dart';
import '../../pagamento/pages/pagamento_page.dart';
import '../models/bill_model.dart';

class ActionButtons extends StatelessWidget {
  final Bill bill;
  final VoidCallback onPayment;
  final VoidCallback onNegotiation;
  final VoidCallback?
  onDownloadDocument; // ✅ Novo callback opcional para baixar documento

  const ActionButtons({
    Key? key,
    required this.bill,
    required this.onPayment,
    required this.onNegotiation,
    this.onDownloadDocument, // ✅ Opcional, pode ser nulo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🔍 ActionButtons - Status do débito ${bill.id}: ${bill.status}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // ✅ Botão para débitos pendentes
          if (bill.status == 'pending')
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
                          nomeCliente: bill.client,
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

          // ✅ Botão para débitos em andamento (pagar parcela)
          if (bill.status == 'in_progress' && bill.installment != null)
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
                          parcelaAtual: bill.installment!.current,
                          totalParcelas: bill.installment!.total,
                          valorPersonalizado: bill.installment!.value,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.credit_card),
                  label: Text(
                    'Pagar Parcela ${bill.installment!.current}/${bill.installment!.total}',
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

          // ✅ Botão para débitos finalizados (BAIXAR DOCUMENTO)
          if (bill.status == 'completed')
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed:
                      onDownloadDocument ??
                      () {
                        // Ação padrão se o callback não for fornecido
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
                    backgroundColor:
                        Colors.purple, // ✅ Cor roxa para diferenciar
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

          // ✅ Botões de compartilhar e baixar PDF (aparecem para todos)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Compartilhar')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Baixar PDF')),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Baixar PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
