class Contrato {
  final String numeroContrato;
  final int clienteId;
  final DateTime vencimento;
  final double valorTotal;
  final String filial;

  Contrato({
    required this.numeroContrato,
    required this.clienteId,
    required this.vencimento,
    required this.valorTotal,
    required this.filial,
  });

  factory Contrato.fromJson(Map<String, dynamic> json) {
    return Contrato(
      numeroContrato: json['numero_contrato'],
      clienteId: json['cliente_id'],
      vencimento: DateTime.parse(json['vencimento']),
      valorTotal: (json['valor_total'] ?? 0).toDouble(),
      filial: json['filial'],
    );
  }
}
