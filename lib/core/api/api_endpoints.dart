// lib/core/api/api_endpoints.dart

class ApiEndpoints {
  static const String baseUrlDev = 'http://127.0.0.1:5000';
  static const String baseUrlProd = 'https://cob-ale.onrender.com';
  static const String baseUrl = baseUrlProd;

  // Auth
  static const String clienteLogin = '/clientes/login';

  // Clientes
  static const String clientes = '/clientes';
  static const String clientesPorCpf = '/clientes/buscar_por_cpf';
  static const String clientesPorNome = '/clientes/buscar_por_nome';
  static const String clientesPorTelefone = '/clientes/buscar_por_telefone';

  // Contratos
  static const String contratos = '/contratos';
  static const String contratosPorCliente = '/contratos/buscar_por_cliente';
  static const String contratosPorFilial = '/contratos/buscar_por_filial';

  // Acordos
  static const String acordos = '/acordos';
  static const String acordosPorCliente = '/acordos/buscar_por_cliente';
  static const String acordosPorContrato = '/acordos/buscar_por_contrato';
  static const String acordosPorStatus = '/acordos/buscar_por_status';

  // Simulação
  static const String simularAcordo = '/acordos/simular';

  // Boletos
  static const String infoBoleto = '/acordos/info_boleto';
  static const String gerarBoleto = '/acordos/gerar_boleto';
  static const String enviarBoleto = '/acordos/enviar_boleto';
  static const String codigoBarras = '/acordos/codigobr';
}
