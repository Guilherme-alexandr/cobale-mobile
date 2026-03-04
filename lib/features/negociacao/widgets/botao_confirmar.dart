import 'package:flutter/material.dart';

class BotaoConfirmar extends StatelessWidget {
  final bool processando;
  final VoidCallback aoPressionar;

  const BotaoConfirmar({
    Key? key,
    required this.processando,
    required this.aoPressionar,
  }) : super(key: key);

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
              ? Container(
                  width: 20,
                  height: 20,
                  child: const CircularProgressIndicator(
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
