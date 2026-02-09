import 'package:flutter/material.dart';

class CpfInput extends StatelessWidget {
  final TextEditingController controller;

  const CpfInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'CPF',
        border: OutlineInputBorder(),
      ),
    );
  }
}
