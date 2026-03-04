class Debito {
  final int id;
  final String descricao;
  final double valor;
  final DateTime vencimento;
  final bool pago;
  final DateTime? dataPagamento;
  final String clienteNome;

  Debito({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.vencimento,
    required this.pago,
    this.dataPagamento,
    required this.clienteNome,
  });
}
