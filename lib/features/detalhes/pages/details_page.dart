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
    Key? key,
    required this.billId,
    required this.onBack,
    required this.onPayment,
    required this.onNegotiation,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final DetailsController _controller;
  Bill? _bill;
  Map<String, dynamic>? _statusInfo;
  double? _total;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = DetailsController();
    _loadBillData();
  }

  void _loadBillData() {
    try {
      final bill = _controller.getBillById(widget.billId);
      if (bill == null) {
        setState(() {
          _errorMessage = "Cobrança não encontrada";
        });
        return;
      }

      setState(() {
        _bill = bill;
        _statusInfo = _controller.getStatusInfo(bill.status);

        double sum = 0;
        for (var item in bill.items) {
          sum += item.total;
        }
        _total = sum;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao carregar dados: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
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
                onPressed: widget.onBack,
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_bill == null || _statusInfo == null || _total == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                ClientInfoCard(bill: _bill!),
                const SizedBox(height: 16),
                BillingDetailsCard(bill: _bill!),
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
