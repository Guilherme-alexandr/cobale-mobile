// lib/features/detalhes/models/bill_model.dart

class BillItem {
  final String description;
  final int quantity;
  final double unitValue;

  BillItem({
    required this.description,
    required this.quantity,
    required this.unitValue,
  });

  double get total => quantity * unitValue;

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      description: json['description'],
      quantity: json['quantity'],
      unitValue: json['unitValue'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unitValue': unitValue,
    };
  }
}

class Installment {
  final double entrada;
  final int quantidadeParcelas;
  final double valorParcela;
  final double valorTotalParcelas;
  final int? parcelaAtual;

  Installment({
    required this.entrada,
    required this.quantidadeParcelas,
    required this.valorParcela,
    required this.valorTotalParcelas,
    this.parcelaAtual,
  });

  int get current => parcelaAtual ?? 1;
  int get total => quantidadeParcelas;
  double get value => valorParcela;

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      entrada: json['entrada']?.toDouble() ?? 0,
      quantidadeParcelas: json['quantidade_parcelas'],
      valorParcela: json['valor_parcela'].toDouble(),
      valorTotalParcelas: json['valor_total_parcelas'].toDouble(),
      parcelaAtual: json['parcela_atual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entrada': entrada,
      'quantidade_parcelas': quantidadeParcelas,
      'valor_parcela': valorParcela,
      'valor_total_parcelas': valorTotalParcelas,
      'parcela_atual': parcelaAtual,
    };
  }
}

class Bill {
  final int id;
  final String contratoId;
  String? client; // Nome do cliente
  String? email; // Email do cliente (adicionado)
  String? phone; // Telefone do cliente (adicionado)
  final double value;
  final DateTime dueDate;
  final DateTime issueDate;
  final String status;
  final String description;
  final List<BillItem> items;
  final Installment? installment;
  final String tipoPagamento;
  final int qtdParcelas;
  final double desconto;
  final double juros;

  Bill({
    required this.id,
    required this.contratoId,
    this.client,
    this.email,
    this.phone,
    required this.value,
    required this.dueDate,
    required this.issueDate,
    required this.status,
    required this.description,
    required this.items,
    this.installment,
    required this.tipoPagamento,
    required this.qtdParcelas,
    required this.desconto,
    required this.juros,
  });

  String get formattedId => '#${id.toString().padLeft(6, '0')}';

  // Mapear status da API para status do app
  String get appStatus {
    switch (status) {
      case 'em andamento':
        return 'in_progress';
      case 'finalizado':
      case 'concluido':
        return 'completed';
      case 'cancelado':
      case 'quebrado':
        return 'cancelled';
      default:
        return 'pending';
    }
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    // Processar parcelamento
    Installment? installment;
    if (json['parcelamento'] != null && json['parcelamento'] is Map) {
      installment = Installment.fromJson(json['parcelamento']);
    }

    return Bill(
      id: json['id'],
      contratoId: json['contrato_id'],
      client: json['cliente_nome'] ?? json['cliente'],
      email: json['cliente_email'] ?? json['email'],
      phone: json['cliente_telefone'] ?? json['telefone'],
      value: json['valor_total'].toDouble(),
      dueDate: DateTime.parse(json['vencimento']),
      issueDate: json['data_emissao'] != null
          ? DateTime.parse(json['data_emissao'])
          : DateTime.now(),
      status: json['status'],
      description:
          json['descricao'] ??
          'Acordo ${json['tipo_pagamento']} - ${json['qtd_parcelas']}x',
      items: json['items'] != null
          ? (json['items'] as List).map((i) => BillItem.fromJson(i)).toList()
          : [],
      installment: installment,
      tipoPagamento: json['tipo_pagamento'],
      qtdParcelas: json['qtd_parcelas'],
      desconto: json['desconto']?.toDouble() ?? 0,
      juros: json['juros']?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contrato_id': contratoId,
      'cliente': client,
      'email': email,
      'telefone': phone,
      'valor_total': value,
      'vencimento': dueDate.toIso8601String(),
      'data_emissao': issueDate.toIso8601String(),
      'status': status,
      'descricao': description,
      'items': items.map((i) => i.toJson()).toList(),
      'parcelamento': installment?.toJson(),
      'tipo_pagamento': tipoPagamento,
      'qtd_parcelas': qtdParcelas,
      'desconto': desconto,
      'juros': juros,
    };
  }
}
