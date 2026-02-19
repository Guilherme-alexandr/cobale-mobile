import 'package:flutter/material.dart';
import '../../debitos/models/debito_model.dart';
import '../controllers/negociacao_controller.dart';
import '../models/simulacao_model.dart';

class NegociacaoPage extends StatefulWidget {
  final Debito debito;

  const NegociacaoPage({super.key, required this.debito});

  @override
  State<NegociacaoPage> createState() => _NegociacaoPageState();
}

class _NegociacaoPageState extends State<NegociacaoPage> {
  final controller = NegociacaoController();

  bool aVista = true;
  int parcelas = 1;
  Simulacao? simulacao;

  void _simular() {
    setState(() {
      simulacao = controller.simular(
        valorOriginal: widget.debito.valor,
        aVista: aVista,
        parcelas: parcelas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Negociação')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valor original: R\$ ${widget.debito.valor.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            const Text('Tipo de negociação'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('À vista'),
                    value: true,
                    groupValue: aVista,
                    onChanged: (value) {
                      setState(() {
                        aVista = value!;
                        parcelas = 1;
                        simulacao = null; // limpa simulação anterior
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Parcelado'),
                    value: false,
                    groupValue: aVista,
                    onChanged: (value) {
                      setState(() {
                        aVista = value!;
                        parcelas = 2;
                        simulacao = null;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (!aVista)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('Quantidade de parcelas'),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      IconButton(
                        onPressed: parcelas > 2
                            ? () {
                                setState(() {
                                  parcelas--;
                                  simulacao = null;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                      ),

                      Text(
                        parcelas.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),

                      IconButton(
                        onPressed: parcelas < 12
                            ? () {
                                setState(() {
                                  parcelas++;
                                  simulacao = null;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _simular,
                child: const Text('Simular'),
              ),
            ),

            const SizedBox(height: 20),

            if (simulacao != null) ...[
              Text(
                'Valor com desconto: R\$ ${simulacao!.valorComDesconto.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Parcelas: ${simulacao!.parcelas}x de R\$ ${simulacao!.valorParcela.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // FUTURO: confirmar acordo (API)
                  },
                  child: const Text('Confirmar Acordo'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
