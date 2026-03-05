import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/bill_card.dart';
import '../widgets/status_filter_bar.dart';
import '../../detalhes/pages/details_page.dart';
import '../../detalhes/models/bill_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String statusFilter = "all";

  final List<Bill> mockBills = [
    Bill(
      id: 1,
      client: "João Silva",
      email: "joao.silva@email.com",
      phone: "(11) 98765-4321",
      value: 1250.00,
      dueDate: DateTime(2026, 2, 15),
      issueDate: DateTime(2026, 2, 5),
      status: "pending",
      description: "Serviços de consultoria - Janeiro 2026",
      items: [
        BillItem(description: "Consultoria", quantity: 10, unitValue: 125.00),
      ],
    ),
    Bill(
      id: 2,
      client: "Maria Santos",
      email: "maria.santos@email.com",
      phone: "(11) 91234-5678",
      value: 850.50,
      dueDate: DateTime(2026, 2, 14),
      issueDate: DateTime(2026, 1, 14),
      status: "in_progress",
      description: "Manutenção - Janeiro 2026",
      items: [
        BillItem(description: "Manutenção", quantity: 1, unitValue: 850.50),
      ],
      installment: Installment(current: 3, total: 6, value: 141.75),
    ),
    Bill(
      id: 3,
      client: "Pedro Oliveira",
      email: "pedro.oliveira@email.com",
      phone: "(11) 99876-5432",
      value: 2100.00,
      dueDate: DateTime(2026, 2, 20),
      issueDate: DateTime(2026, 2, 10),
      status: "pending",
      description: "Desenvolvimento de sistema customizado",
      items: [
        BillItem(description: "Análise", quantity: 1, unitValue: 500.00),
        BillItem(
          description: "Desenvolvimento",
          quantity: 1,
          unitValue: 1600.00,
        ),
      ],
    ),
    Bill(
      id: 4,
      client: "Ana Costa",
      email: "ana.costa@email.com",
      phone: "(11) 98888-9999",
      value: 500.00,
      dueDate: DateTime(2026, 2, 10),
      issueDate: DateTime(2026, 1, 10),
      status: "completed", // ← STATUS CORRETO
      description: "Consultoria pontual",
      items: [
        BillItem(description: "Consultoria", quantity: 5, unitValue: 100.00),
      ],
    ),
    Bill(
      id: 5,
      client: "Carlos Souza",
      email: "carlos.souza@email.com",
      phone: "(11) 97777-8888",
      value: 1800.00,
      dueDate: DateTime(2026, 2, 13),
      issueDate: DateTime(2026, 1, 13),
      status: "in_progress",
      description: "Contrato mensal - Janeiro 2026",
      items: [
        BillItem(description: "Mensalidade", quantity: 1, unitValue: 1800.00),
      ],
      installment: Installment(current: 1, total: 12, value: 153.00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pending = mockBills.where((b) => b.status == "pending").length;
    final inProgress = mockBills.where((b) => b.status == "in_progress").length;
    final completed = mockBills.where((b) => b.status == "completed").length;

    final filtered = statusFilter == "all"
        ? mockBills
        : mockBills.where((b) => b.status == statusFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Pendentes",
                            count: pending,
                            color: Colors.orange,
                            icon: Icons.access_time,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: "Em Andamento",
                            count: inProgress,
                            color: Colors.blue,
                            icon: Icons.sync,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: "Finalizadas",
                            count: completed,
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    StatusFilterBar(
                      selected: statusFilter,
                      total: mockBills.length,
                      pending: pending,
                      inProgress: inProgress,
                      completed: completed,
                      onSelect: (value) {
                        setState(() {
                          statusFilter = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    if (filtered.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'Nenhuma cobrança encontrada',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: filtered.map((bill) {
                          return BillCard(
                            bill: bill,
                            onDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailsPage(
                                    billId: bill.id,
                                    onBack: () => Navigator.pop(context),
                                    onPayment: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Pagamento processado'),
                                        ),
                                      );
                                    },
                                    onNegotiation: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Negociação iniciada'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
