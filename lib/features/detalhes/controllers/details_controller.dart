// lib/features/detalhes/controllers/details_controller.dart

import '../models/bill_model.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/acordo_service.dart';
import '../../../core/services/cliente_service.dart';
import '../../../core/services/contrato_service.dart';

class DetailsController {
  final AcordoService _acordoService = AcordoService();
  final ClienteService _clienteService = ClienteService();
  final ContratoService _contratoService = ContratoService();

  Bill? _bill;
  Map<String, dynamic>? _clienteData;
  String? _filial;

  Bill? get bill => _bill;
  Map<String, dynamic>? get clienteData => _clienteData;
  String? get filial => _filial;

  Future<Bill?> getBillById(int id) async {
    try {
      // Cria a versão formatada do ID com 6 dígitos (ex: 60105 vira "060105")
      String numeroContratoFormatado = id.toString().padLeft(6, '0');

      debugPrint(
        '🔍 Buscando detalhes para o ID: $id (Formatado: $numeroContratoFormatado)',
      );
      final acordo = await _acordoService.buscarAcordoPorId(id);

      if (acordo != null) {
        debugPrint('✅ Acordo encontrado!');
        _bill = acordo;

        final contrato = await _contratoService.buscarContratoPorNumero(
          acordo.contratoId,
        );
        if (contrato != null) {
          _filial = contrato.filial;
          final cliente = await _clienteService.buscarClientePorId(
            contrato.clienteId,
          );
          if (cliente != null) _clienteData = cliente;
        }
        return _bill;
      }

      debugPrint(
        '⚠️ Acordo não encontrado. Tentando buscar como Contrato puro...',
      );

      final contrato = await _contratoService.buscarContratoPorNumero(
        numeroContratoFormatado,
      );

      if (contrato != null) {
        debugPrint('✅ Contrato puro encontrado!');
        _bill = Bill(
          id: id,
          contratoId: contrato.numeroContrato,
          value: contrato.valorTotal,
          dueDate: contrato.vencimento,
          issueDate: DateTime.now(),
          status: 'pendente',
          description: 'Contrato Original',
          items: [],
          tipoPagamento: 'Não definido',
          qtdParcelas: 1,
          desconto: 0.0,
          juros: 0.0,
        );

        _filial = contrato.filial;

        final cliente = await _clienteService.buscarClientePorId(
          contrato.clienteId,
        );
        if (cliente != null) {
          _clienteData = cliente;
        }

        return _bill;
      }

      debugPrint(
        '❌ Nenhum Acordo ou Contrato encontrado para: $numeroContratoFormatado',
      );
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar detalhes: $e');
      return null;
    }
  }

  String getClientName() {
    return (_clienteData?['nome'] as String?) ?? 'Cliente não encontrado';
  }

  String getClientEmail() {
    return (_clienteData?['email'] as String?) ?? 'Email não disponível';
  }

  String getClientPhone() {
    return (_clienteData?['telefone'] as String?) ?? 'Telefone não disponível';
  }

  String getFilial() {
    return _filial ?? 'Filial não informada';
  }

  Map<String, dynamic> getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'finalizado':
      case 'concluido':
        return {
          'badgeText': 'Finalizada',
          'icon': 'check_circle',
          'colorHex': 0xFF4CAF50,
        };
      case 'em andamento':
        return {
          'badgeText': 'Em Andamento',
          'icon': 'hourglass_empty',
          'colorHex': 0xFF2196F3,
        };
      case 'cancelado':
      case 'quebrado':
        return {
          'badgeText': 'Cancelado',
          'icon': 'cancel',
          'colorHex': 0xFFF44336,
        };
      default:
        return {
          'badgeText': 'Pendente',
          'icon': 'access_time',
          'colorHex': 0xFFFFC107,
        };
    }
  }

  String get client => getClientName();
  String get email => getClientEmail();
  String get phone => getClientPhone();
}
