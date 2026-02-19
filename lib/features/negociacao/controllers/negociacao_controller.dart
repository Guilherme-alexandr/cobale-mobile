import '../models/simulacao_model.dart';

class NegociacaoController {
  Simulacao simular({
    required double valorOriginal,
    required bool aVista,
    int parcelas = 1,
  }) {
    double desconto;

    if (aVista) {
      desconto = 0.20; // 20% de desconto para pagamento à vista
    } else {
      desconto = 0.10; // 10% de desconto para pagamento parcelado
    }

    final valorComDesconto = valorOriginal * (1 - desconto);
    final valorParcela = valorComDesconto / parcelas;

    return Simulacao(
      valorOriginal: valorOriginal,
      valorComDesconto: valorComDesconto,
      parcelas: parcelas,
      valorParcela: valorParcela,
    );
  }
}
