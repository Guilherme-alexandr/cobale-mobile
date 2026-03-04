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
}

class Installment {
  final int current;
  final int total;
  final double value;

  Installment({
    required this.current,
    required this.total,
    required this.value,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      current: json['current'],
      total: json['total'],
      value: json['value'].toDouble(),
    );
  }
}

class Bill {
  final int id;
  final String client;
  final String email;
  final String phone;
  final double value;
  final DateTime dueDate;
  final DateTime issueDate;
  final String status;
  final String description;
  final List<BillItem> items;
  final Installment? installment;

  Bill({
    required this.id,
    required this.client,
    required this.email,
    required this.phone,
    required this.value,
    required this.dueDate,
    required this.issueDate,
    required this.status,
    required this.description,
    required this.items,
    this.installment,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      client: json['client'],
      email: json['email'],
      phone: json['phone'],
      value: json['value'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      issueDate: DateTime.parse(json['issueDate']),
      status: json['status'],
      description: json['description'],
      items: (json['items'] as List)
          .map((item) => BillItem.fromJson(item))
          .toList(),
      installment: json['installment'] != null
          ? Installment.fromJson(json['installment'])
          : null,
    );
  }

  String get formattedId => '#${id.toString().padLeft(6, '0')}';
}
