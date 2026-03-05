import 'package:flutter/material.dart';
import '../controllers/pagamento_controller.dart';
import '../widgets/card_sucesso_pagamento.dart';
import '../widgets/card_valor_pagamento.dart';
import '../widgets/card_cartao_credito.dart';
import '../widgets/card_pix.dart';
import '../widgets/card_boleto.dart';

class PagamentoPage extends StatefulWidget {
  final VoidCallback aoVoltar;
  final VoidCallback aoConfirmar;
  final int? idCobranca;
  final int? parcelaAtual;
  final int? totalParcelas;
  final double? valorPersonalizado;

  const PagamentoPage({
    Key? key,
    required this.aoVoltar,
    required this.aoConfirmar,
    this.idCobranca,
    this.parcelaAtual,
    this.totalParcelas,
    this.valorPersonalizado,
  }) : super(key: key);

  @override
  State<PagamentoPage> createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage>
    with SingleTickerProviderStateMixin {
  late final PagamentoController _controller;
  late TabController _tabController;

  bool processando = false;
  bool sucesso = false;
  String metodoPagamento = 'cartao';

  @override
  void initState() {
    super.initState();
    _controller = PagamentoController();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            metodoPagamento = 'cartao';
            break;
          case 1:
            metodoPagamento = 'pix';
            break;
          case 2:
            metodoPagamento = 'boleto';
            break;
        }
      });
    }
  }

  double get valorPagamento {
    if (widget.valorPersonalizado != null) {
      return widget.valorPersonalizado!;
    }
    return 1250.00;
  }

  void _processarPagamento([Map<String, String>? dadosCartao]) async {
    setState(() {
      processando = true;
    });

    bool sucessoPagamento = false;

    if (metodoPagamento == 'cartao' && dadosCartao != null) {
      sucessoPagamento = await _controller.processarPagamentoCartao(
        numeroCartao: dadosCartao['numeroCartao']!,
        nomeCartao: dadosCartao['nomeCartao']!,
        validade: dadosCartao['validade']!,
        cvv: dadosCartao['cvv']!,
        valor: valorPagamento,
      );
    } else if (metodoPagamento == 'pix') {
      sucessoPagamento = await _controller.processarPagamentoPix();
    } else if (metodoPagamento == 'boleto') {
      sucessoPagamento = await _controller.processarPagamentoBoleto();
    }

    if (mounted) {
      setState(() {
        processando = false;
        sucesso = sucessoPagamento;
      });
    }
  }

  void _confirmarPagamentoPix() {
    // Para PIX, o pagamento é confirmado imediatamente após copiar o código
    _processarPagamento();
  }

  void _confirmarPagamentoBoleto() {
    // Para boleto, mostra um diálogo explicativo antes de confirmar
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar pagamento?'),
        content: const Text(
          'O pagamento via boleto pode levar até 3 dias úteis para ser compensado. '
          'Deseja confirmar que já realizou o pagamento?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processarPagamento();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Sim, já paguei'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tela de sucesso
    if (sucesso) {
      return CardSucessoPagamento(
        valor: valorPagamento,
        metodoPagamento: metodoPagamento, // ✅ Passando o método de pagamento
        parcelaAtual: widget.parcelaAtual,
        totalParcelas: widget.totalParcelas,
        aoConfirmar: widget.aoConfirmar,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          // Header
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
                  'Pagamento',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  widget.parcelaAtual != null
                      ? 'Parcela ${widget.parcelaAtual}/${widget.totalParcelas}'
                      : 'Escolha a forma de pagamento',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            pinned: true,
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Card de valor
                CardValorPagamento(
                  valor: valorPagamento,
                  parcelaAtual: widget.parcelaAtual,
                  totalParcelas: widget.totalParcelas,
                ),

                const SizedBox(height: 16),

                // Abas de métodos de pagamento
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    tabs: const [
                      Tab(icon: Icon(Icons.credit_card), text: 'Cartão'),
                      Tab(icon: Icon(Icons.qr_code), text: 'PIX'),
                      Tab(icon: Icon(Icons.receipt), text: 'Boleto'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Conteúdo das abas - AGORA COM CONFIRMAÇÃO CORRETA
                _buildConteudoAba(),

                const SizedBox(height: 16),

                // Informação de segurança
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Pagamento seguro e protegido',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Método separado para construir o conteúdo da aba atual
  Widget _buildConteudoAba() {
    switch (_tabController.index) {
      case 0: // Cartão
        return CardCartaoCredito(
          valor: valorPagamento,
          processando: processando,
          aoProcessar: _processarPagamento,
        );

      case 1: // PIX
        return CardPix(
          aoCopiarCodigo: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Código PIX copiado!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          },
          aoConfirmarPagamento: _confirmarPagamentoPix, // ✅ Novo callback
        );

      case 2: // Boleto
        return CardBoleto(
          vencimento: DateTime.now().add(const Duration(days: 3)),
          aoCopiarCodigo: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Código do boleto copiado!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          },
          aoImprimir: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Boleto gerado para impressão!'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 1),
              ),
            );
          },
          aoConfirmarPagamento: _confirmarPagamentoBoleto, // ✅ Novo callback
        );

      default:
        return const SizedBox();
    }
  }
}
