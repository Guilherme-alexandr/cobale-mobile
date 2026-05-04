// lib/features/home/pages/home_page.dart

import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/bill_card.dart';
import '../widgets/status_filter_bar.dart';
import '../controllers/home_controller.dart';
import '../../detalhes/pages/details_page.dart';
import '../../../core/widgets/activity_tracker.dart';
import '../../../core/storage/secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  String statusFilter = "all";

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _controller.carregarDados();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ActivityTracker(
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              const HomeHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _controller.refresh();
                    await SecureStorage().updateLastActivity();
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        SecureStorage().updateLastActivity();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: _buildBody(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Loading com skeleton
    if (_controller.isLoading) {
      return _buildSkeletonLoading();
    }

    // Erro
    if (_controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage!,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.carregarDados(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    // Refresh em background (quando está recarregando)
    if (_controller.isRefreshing && _controller.itens.isNotEmpty) {
      return Column(
        children: [
          // Mostrar os itens existentes
          _buildContent(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      );
    }

    return _buildContent();
  }

  Widget _buildContent() {
    final filtered = statusFilter == "all"
        ? _controller.itens
        : _controller.itens.where((i) => i.status == statusFilter).toList();

    return Column(
      children: [
        // STATS CARDS
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "Pendentes",
                count: _controller.pendingCount,
                color: Colors.orange,
                icon: Icons.access_time,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: "Em Andamento",
                count: _controller.inProgressCount,
                color: Colors.blue,
                icon: Icons.sync,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: "Finalizadas",
                count: _controller.completedCount,
                color: Colors.green,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // FILTRO
        StatusFilterBar(
          selected: statusFilter,
          total: _controller.itens.length,
          pending: _controller.pendingCount,
          inProgress: _controller.inProgressCount,
          completed: _controller.completedCount,
          onSelect: (value) {
            setState(() {
              statusFilter = value;
            });
          },
        ),

        const SizedBox(height: 20),

        // LISTA
        if (filtered.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma cobrança encontrada',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: filtered.map((item) {
              return BillCard(
                item: item,
                onDetails: () {
                  debugPrint('🛑 BOTÃO CLICADO! ID: ${item.id}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailsPage(
                        billId: item.id,
                        onBack: () => Navigator.pop(context),
                        onPayment: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pagamento processado'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _controller.carregarDados();
                        },
                        onNegotiation: () {
                          _controller.carregarDados();
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSkeletonLoading() {
    return Column(
      children: [
        // Skeleton para os stat cards
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Skeleton para o filtro
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 20),

        ...List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
