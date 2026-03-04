import '../models/bill_model.dart';

class DetailsController {
  final List<Bill> _bills = [
    Bill(
      id: 1,
      client: 'João Silva',
      email: 'joao.silva@email.com',
      phone: '(11) 98765-4321',
      value: 1250.00,
      dueDate: DateTime(2026, 2, 15),
      issueDate: DateTime(2026, 2, 5),
      status: 'pending',
      description: 'Serviços de consultoria e desenvolvimento - Janeiro 2026',
      items: [
        BillItem(
          description: 'Consultoria técnica',
          quantity: 10,
          unitValue: 80.00,
        ),
        BillItem(
          description: 'Desenvolvimento de features',
          quantity: 5,
          unitValue: 90.00,
        ),
      ],
    ),
    Bill(
      id: 2,
      client: 'Maria Santos',
      email: 'maria.santos@email.com',
      phone: '(11) 91234-5678',
      value: 850.50,
      dueDate: DateTime(2026, 2, 14),
      issueDate: DateTime(2026, 1, 14),
      status: 'in_progress',
      description: 'Serviço de manutenção - Janeiro 2026',
      items: [
        BillItem(
          description: 'Manutenção preventiva',
          quantity: 1,
          unitValue: 850.50,
        ),
      ],
      installment: Installment(current: 3, total: 6, value: 141.75),
    ),
    Bill(
      id: 3,
      client: 'Pedro Oliveira',
      email: 'pedro.oliveira@email.com',
      phone: '(11) 99876-5432',
      value: 2100.00,
      dueDate: DateTime(2026, 2, 20),
      issueDate: DateTime(2026, 2, 10),
      status: 'pending',
      description: 'Desenvolvimento de sistema customizado',
      items: [
        BillItem(
          description: 'Análise e levantamento',
          quantity: 1,
          unitValue: 500.00,
        ),
        BillItem(
          description: 'Desenvolvimento',
          quantity: 1,
          unitValue: 1600.00,
        ),
      ],
    ),
    Bill(
      id: 4,
      client: 'Ana Costa',
      email: 'ana.costa@email.com',
      phone: '(11) 98888-9999',
      value: 500.00,
      dueDate: DateTime(2026, 2, 10),
      issueDate: DateTime(2026, 1, 10),
      status: 'completed',
      description: 'Consultoria pontual',
      items: [
        BillItem(
          description: 'Consultoria especializada',
          quantity: 5,
          unitValue: 100.00,
        ),
      ],
    ),
    Bill(
      id: 5,
      client: 'Carlos Souza',
      email: 'carlos.souza@email.com',
      phone: '(11) 97777-8888',
      value: 1800.00,
      dueDate: DateTime(2026, 2, 13),
      issueDate: DateTime(2026, 1, 13),
      status: 'in_progress',
      description: 'Contrato mensal - Janeiro 2026',
      items: [
        BillItem(description: 'Mensalidade', quantity: 1, unitValue: 1800.00),
      ],
      installment: Installment(current: 1, total: 12, value: 153.00),
    ),
  ];

  Bill? getBillById(int id) {
    try {
      return _bills.firstWhere((bill) => bill.id == id);
    } catch (e) {
      return _bills.first;
    }
  }

  Map<String, dynamic> getStatusInfo(String status) {
    switch (status) {
      case 'completed':
        return {
          'badgeText': 'Finalizada',
          'icon': 'check_circle',
          'colorHex': 0xFF4CAF50,
        };
      case 'in_progress':
        return {
          'badgeText': 'Em Andamento',
          'icon': 'hourglass_empty',
          'colorHex': 0xFF2196F3,
        };
      default:
        return {
          'badgeText': 'Pendente',
          'icon': 'access_time',
          'colorHex': 0xFFFFC107,
        };
    }
  }
}
