// lib/features/detalhes/widgets/client_info_card.dart

import 'package:flutter/material.dart';

class ClientInfoCard extends StatelessWidget {
  final String clientName;
  final String clientEmail;
  final String clientPhone;

  const ClientInfoCard({
    super.key,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações do Cliente',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person, 'Nome', clientName),
            const Divider(height: 24),
            _buildInfoRow(Icons.email, 'E-mail', clientEmail),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Telefone', clientPhone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
