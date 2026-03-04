import 'package:flutter/material.dart';

class StatusFilterBar extends StatelessWidget {
  final String selected;
  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final Function(String) onSelect;

  const StatusFilterBar({
    super.key,
    required this.selected,
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildButton("all", "Todas ($total)", Colors.blue),
          _buildButton("pending", "Pendentes ($pending)", Colors.orange),
          _buildButton(
            "in_progress",
            "Em Andamento ($inProgress)",
            Colors.blue,
          ),
          _buildButton("completed", "Finalizadas ($completed)", Colors.green),
        ],
      ),
    );
  }

  Widget _buildButton(String value, String text, Color color) {
    final bool isActive = selected == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive ? color : Colors.white,
          foregroundColor: isActive ? Colors.white : color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => onSelect(value),
        child: Text(text),
      ),
    );
  }
}
