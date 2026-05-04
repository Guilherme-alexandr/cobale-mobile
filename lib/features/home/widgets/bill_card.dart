// lib/features/home/widgets/bill_card.dart

import 'package:flutter/material.dart';
import '../models/home_item_model.dart';

class BillCard extends StatelessWidget {
  final HomeItem item;
  final VoidCallback onDetails;

  const BillCard({super.key, required this.item, required this.onDetails});

  Color _getStatusColor() {
    switch (item.status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText() {
    switch (item.status) {
      case 'completed':
        return 'Finalizada';
      case 'in_progress':
        return 'Em Andamento';
      default:
        return 'Pendente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.clientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (item.filial.isNotEmpty)
                      Text(
                        item.filial,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              _buildStatus(),
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
                    "R\$ ${item.value.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Vencimento: ${_formatDate(item.dueDate)}",
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

  Widget _buildStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(color: _getStatusColor(), fontSize: 12),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
