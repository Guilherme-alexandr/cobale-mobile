// lib/features/detalhes/pages/details_page.dart

import 'package:flutter/material.dart';
import '../controllers/details_controller.dart';
import '../models/bill_model.dart';
import '../widgets/status_card.dart';
import '../widgets/client_info_card.dart';
import '../widgets/billing_details_card.dart';
import '../widgets/items_card.dart';
import '../widgets/action_buttons.dart';

class DetailsPage extends StatefulWidget {
  final int billId;
  final VoidCallback onBack;
  final VoidCallback onPayment;
  final VoidCallback onNegotiation;

  const DetailsPage({
    super.key,
    required this.billId,
    required this.onBack,
    required this.onPayment,
    required this.onNegotiation,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final DetailsController _controller = DetailsController();

  bool _isLoading = true;
  String? _errorMessage;
  Bill? _bill;
  Map<String, dynamic>? _statusInfo;
  double? _total;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bill = await _controller.getBillById(widget.billId);

      if (bill == null) {
        setState(() {
          _errorMessage = 'Cobrança não encontrada';
          _isLoading = false;
        });
        return;
      }

      _bill = bill;
      _statusInfo = _controller.getStatusInfo(bill.status);

      // Calcular total dos itens (se não tiver itens, usar valor total)
      if (bill.items.isNotEmpty) {
        // ✅ Adicionado <double> e 0.0
        _total = bill.items.fold<double>(0.0, (sum, item) => sum + item.total);
      } else {
        _total = bill.value;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando detalhes...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
            color: Colors.black,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
              color: Colors.black,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detalhes da Cobrança',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  _bill!.formattedId,
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
                StatusCard(bill: _bill!, statusInfo: _statusInfo!),
                const SizedBox(height: 16),
                ClientInfoCard(
                  clientName: _controller.getClientName(),
                  clientEmail: _controller.getClientEmail(),
                  clientPhone: _controller.getClientPhone(),
                ),
                const SizedBox(height: 16),
                BillingDetailsCard(
                  issueDate: _bill!.issueDate,
                  description: _bill!.description,
                  filial: _controller.getFilial(),
                  contratoId: _bill!.contratoId,
                ),
                const SizedBox(height: 16),
                ItemsCard(bill: _bill!, total: _total!),
                const SizedBox(height: 24),
                ActionButtons(
                  bill: _bill!,
                  onPayment: widget.onPayment,
                  onNegotiation: widget.onNegotiation,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
