import 'package:flutter/material.dart';
import '../../detalhes/models/bill_model.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onDetails;

  const BillCard({super.key, required this.bill, this.onDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bill.client,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              _buildStatus(bill.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "R\$ ${bill.value.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Vencimento: ${_formatDate(bill.dueDate)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: onDetails,
                child: const Text("Detalhes"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildStatus(String status) {
    Color color;
    String text;

    switch (status) {
      case "completed":
        color = Colors.green;
        text = "Finalizada";
        break;
      case "in_progress":
        color = Colors.blue;
        text = "Em Andamento";
        break;
      default:
        color = Colors.orange;
        text = "Pendente";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
