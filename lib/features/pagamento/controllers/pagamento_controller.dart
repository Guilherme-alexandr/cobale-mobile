class PagamentoController {
  static const String pixCode =
      'PIX00020126580014BR.GOV.BCB.PIX0136a1b2c3d4-e5f6-7890-abcd-1234567890ab5204000053039865802BR5925COBALE SISTEMAS LTDA6009SAO PAULO62070503***63044E5A';

  static const String boletoCode =
      '23793.38128 60047.141002 00012.501018 8 95840000125000';

  Future<bool> processarPagamentoCartao({
    required String numeroCartao,
    required String nomeCartao,
    required String validade,
    required String cvv,
    required double valor,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> processarPagamentoPix() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> processarPagamentoBoleto() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  String formatarNumeroCartao(String valor) {
    String numeros = valor.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length > 16) numeros = numeros.substring(0, 16);

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < numeros.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(numeros[i]);
    }
    return buffer.toString();
  }

  String formatarValidade(String valor) {
    String numeros = valor.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length > 4) numeros = numeros.substring(0, 4);

    if (numeros.length >= 3) {
      return '${numeros.substring(0, 2)}/${numeros.substring(2)}';
    }
    return numeros;
  }

  bool validarCartao(String numeroCartao) {
    String numeros = numeroCartao.replaceAll(' ', '');
    return numeros.length == 16;
  }

  bool validarValidade(String validade) {
    if (validade.length != 5) return false;

    try {
      String mes = validade.substring(0, 2);
      String ano = validade.substring(3, 5);

      int mesInt = int.parse(mes);
      int anoInt = int.parse(ano) + 2000;

      DateTime dataValidade = DateTime(anoInt, mesInt + 1, 0);
      DateTime hoje = DateTime.now();

      return dataValidade.isAfter(hoje);
    } catch (e) {
      return false;
    }
  }

  bool validarCVV(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4;
  }

  String getMensagemSucesso({
    required double valor,
    int? parcelaAtual,
    int? totalParcelas,
  }) {
    if (parcelaAtual != null && totalParcelas != null) {
      return 'Pagamento da parcela $parcelaAtual/$totalParcelas de R\$ ${valor.toStringAsFixed(2)} foi processado com sucesso.';
    }
    return 'Seu pagamento de R\$ ${valor.toStringAsFixed(2)} foi processado com sucesso.';
  }
}
