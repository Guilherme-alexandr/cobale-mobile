import 'package:flutter/foundation.dart';
import '../models/debito_model.dart';

class DebitosController {
  final List<Debito> _debitosMock = [
    Debito(
      id: 1,
      descricao: 'Parcela 1 - Contrato 123',
      valor: 550.00,
      vencimento: DateTime.now(),
      pago: false,
      clienteNome: 'João Silva',
    ),
    Debito(
      id: 2,
      descricao: 'Parcela 2 - Contrato 123',
      valor: 550.00,
      vencimento: DateTime.now().add(const Duration(days: 30)),
      pago: false,
      clienteNome: 'João Silva',
    ),
    Debito(
      id: 3,
      descricao: 'Parcela 3 - Contrato 123',
      valor: 550.00,
      vencimento: DateTime.now().add(const Duration(days: 60)),
      pago: false,
      clienteNome: 'João Silva',
    ),
  ];

  List<Debito> listarDebitos() {
    return _debitosMock;
  }

  Debito? buscarDebitoPorId(int id) {
    return _debitosMock.where((debito) => debito.id == id).firstOrNull;
  }

  Future<bool> pagarDebito(int id) async {
    await Future.delayed(const Duration(seconds: 1));

    debugPrint('Débito $id pago com sucesso!');

    return true;
  }

  Future<bool> negociarDebito(int id, Map<String, dynamic> condicoes) async {
    await Future.delayed(const Duration(seconds: 2));

    debugPrint('Débito $id negociado com condições: $condicoes');
    return true;
  }
}
