import 'package:flutter/material.dart';
import '../controllers/negociacao_controller.dart';

class CardDataVencimento extends StatelessWidget {
  final String tipoPagamento;
  final String dataVencimento;
  final Function(String) aoAlterarData;

  const CardDataVencimento({
    Key? key,
    required this.tipoPagamento,
    required this.dataVencimento,
    required this.aoAlterarData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = NegociacaoController();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.getAvisoDataVencimento(tipoPagamento),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: dataVencimento,
              readOnly: true,
              onTap: () async {
                final dataSelecionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (dataSelecionada != null) {
                  final dataFormatada =
                      '${dataSelecionada.year}-${dataSelecionada.month.toString().padLeft(2, '0')}-${dataSelecionada.day.toString().padLeft(2, '0')}';
                  aoAlterarData(dataFormatada);
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_today, size: 18),
                hintText: 'Selecione a data',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: dataVencimento.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => aoAlterarData(''),
                      )
                    : null,
              ),
            ),
            if (dataVencimento.isNotEmpty && tipoPagamento == 'parcelamento')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  controller.getAjudaDataVencimento(tipoPagamento),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
