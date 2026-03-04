import '../models/debito_model.dart';

class DebitosController {
  List<Debito> listarDebitos() {
    return [
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
  }

  Debito? buscarDebitoPorId(int id) {
    try {
      return listarDebitos().firstWhere((debito) => debito.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> pagarDebito(int id) async {
    await Future.delayed(const Duration(seconds: 1));

    print('Débito $id pago com sucesso!');
    return true;
  }

  Future<bool> negociarDebito(int id, Map<String, dynamic> condicoes) async {
    await Future.delayed(const Duration(seconds: 2));

    print('Débito $id negociado com condições: $condicoes');
    return true;
  }
}
