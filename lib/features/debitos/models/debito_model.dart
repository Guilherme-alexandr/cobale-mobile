class Debito {
  final String id;
  final String descricao;
  final double valor;
  final DateTime vencimento;
  final bool pago;

  Debito({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.vencimento,
    required this.pago,
  });
}
