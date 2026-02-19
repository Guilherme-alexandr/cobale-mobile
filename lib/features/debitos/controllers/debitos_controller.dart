import '../models/debito_model.dart';

class DebitosController {
  List<Debito> listarDebitos() {
    return [
      Debito(
        id: '1',
        descricao: 'Parcela 1 - Contrato 123',
        valor: 550.00,
        vencimento: DateTime.now(),
        pago: false,
      ),
      Debito(
        id: '2',
        descricao: 'Parcela 2 - Contrato 123',
        valor: 550.00,
        vencimento: DateTime.now().add(const Duration(days: 30)),
        pago: false,
      ),
      Debito(
        id: '3',
        descricao: 'Parcela 3 - Contrato 123',
        valor: 550.00,
        vencimento: DateTime.now().add(const Duration(days: 60)),
        pago: false,
      ),
    ];
  }
}
