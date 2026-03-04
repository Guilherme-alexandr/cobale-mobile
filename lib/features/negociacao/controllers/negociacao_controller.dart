class NegociacaoController {
  static const double taxaJuros = 0.02;

  double calcularTotalComJuros(double valorDebito, int parcelas, bool isCash) {
    if (isCash) {
      return valorDebito;
    }
    return valorDebito * (1 + taxaJuros * parcelas);
  }

  double calcularValorParcela(double totalComJuros, int parcelas) {
    if (parcelas <= 0) return 0;
    return totalComJuros / parcelas;
  }

  double calcularValorJuros(double valorDebito, double totalComJuros) {
    return totalComJuros - valorDebito;
  }

  String getAvisoDataVencimento(String tipoPagamento) {
    return tipoPagamento == 'dinheiro'
        ? 'Data de Vencimento'
        : 'Vencimento da 1ª Parcela';
  }

  String getAjudaDataVencimento(String tipoPagamento) {
    return tipoPagamento == 'parcelamento'
        ? 'As demais parcelas vencem mensalmente'
        : '';
  }

  bool isDataValida(String dataVencimento) {
    if (dataVencimento.isEmpty) return false;

    try {
      final date = DateTime.parse(dataVencimento);
      final today = DateTime.now();
      return date.isAfter(today) ||
          date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
    } catch (e) {
      return false;
    }
  }

  String getDataMinima() {
    final today = DateTime.now();
    return '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  }
}
