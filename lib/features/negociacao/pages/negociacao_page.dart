import 'package:flutter/material.dart';
import '../controllers/negociacao_controller.dart';
import '../widgets/card_sucesso.dart';
import '../widgets/card_valor.dart';
import '../widgets/card_tipo_pagamento.dart';
import '../widgets/card_simulacao_parcelas.dart';
import '../widgets/card_data_vencimento.dart';
import '../widgets/botao_confirmar.dart';

class NegociacaoPage extends StatefulWidget {
  final int idCobranca;
  final double valorDebito;
  final String nomeCliente;
  final VoidCallback aoVoltar;
  final VoidCallback aoConfirmar;

  const NegociacaoPage({
    Key? key,
    required this.idCobranca,
    required this.valorDebito,
    required this.nomeCliente,
    required this.aoVoltar,
    required this.aoConfirmar,
  }) : super(key: key);

  @override
  State<NegociacaoPage> createState() => _NegociacaoPageState();
}

class _NegociacaoPageState extends State<NegociacaoPage> {
  late final NegociacaoController _controller;

  String tipoPagamento = 'dinheiro';
  int parcelas = 2;
  String dataVencimento = '';
  bool processando = false;
  bool sucesso = false;

  @override
  void initState() {
    super.initState();
    _controller = NegociacaoController();
  }

  double get totalComJuros {
    return _controller.calcularTotalComJuros(
      widget.valorDebito,
      parcelas,
      tipoPagamento == 'dinheiro',
    );
  }

  double get valorParcela {
    return _controller.calcularValorParcela(totalComJuros, parcelas);
  }

  double get valorJuros {
    return _controller.calcularValorJuros(widget.valorDebito, totalComJuros);
  }

  void _aoConfirmar() {
    if (!_controller.isDataValida(dataVencimento)) {
      _mostrarErro('Por favor, selecione uma data de vencimento válida');
      return;
    }

    setState(() {
      processando = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          processando = false;
          sucesso = true;
        });
      }
    });
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sucesso) {
      return CardSucesso(
        pagamentoAVista: tipoPagamento == 'dinheiro',
        valorDebito: widget.valorDebito,
        parcelas: parcelas,
        valorParcela: valorParcela,
        aoConfirmar: widget.aoConfirmar,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.aoVoltar,
              color: Colors.black,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Negociação de Débito',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  widget.nomeCliente,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            pinned: true,
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CardValor(
                  valorDebito: widget.valorDebito,
                  nomeCliente: widget.nomeCliente,
                ),
                const SizedBox(height: 16),

                CardTipoPagamento(
                  tipoPagamento: tipoPagamento,
                  valorDebito: widget.valorDebito,
                  aoAlterar: (valor) {
                    setState(() {
                      tipoPagamento = valor;
                    });
                  },
                ),
                const SizedBox(height: 16),

                if (tipoPagamento == 'parcelamento')
                  CardSimulacaoParcelas(
                    parcelas: parcelas,
                    valorDebito: widget.valorDebito,
                    totalComJuros: totalComJuros,
                    valorParcela: valorParcela,
                    aoAlterarParcelas: (valor) {
                      setState(() {
                        parcelas = valor;
                      });
                    },
                  ),

                if (tipoPagamento == 'parcelamento') const SizedBox(height: 16),

                CardDataVencimento(
                  tipoPagamento: tipoPagamento,
                  dataVencimento: dataVencimento,
                  aoAlterarData: (valor) {
                    setState(() {
                      dataVencimento = valor;
                    });
                  },
                ),

                const SizedBox(height: 24),

                BotaoConfirmar(
                  processando: processando,
                  aoPressionar: _aoConfirmar,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
