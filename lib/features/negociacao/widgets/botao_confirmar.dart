import 'package:flutter/material.dart';

class BotaoConfirmar extends StatelessWidget {
  final bool processando;
  final VoidCallback aoPressionar;

  const BotaoConfirmar({
    super.key,
    required this.processando,
    required this.aoPressionar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: processando ? null : aoPressionar,
          icon: processando
              // ✅ CORRIGIDO AQUI: Container substituído por SizedBox com 'const'
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.check_circle),
          label: Text(
            processando ? 'Processando...' : 'Confirmar Acordo',
            style: const TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: processando ? Colors.grey : Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
