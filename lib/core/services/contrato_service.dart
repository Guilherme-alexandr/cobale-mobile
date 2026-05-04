// lib/core/services/contrato_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../../features/home/models/contrato_model.dart';

class ContratoService {
  final Dio _dio = ApiClient().dio;

  Future<List<Contrato>> buscarContratosPorCliente(int clienteId) async {
    try {
      debugPrint('📋 Buscando contratos do cliente $clienteId');
      debugPrint('📍 URL: ${ApiEndpoints.contratosPorCliente}/$clienteId');

      final response = await _dio.get(
        '${ApiEndpoints.contratosPorCliente}/$clienteId',
        options: Options(validateStatus: (status) => status! < 500),
      );

      debugPrint('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];

        debugPrint('✅ Contratos encontrados: ${data.length}');
        return data.map((json) => Contrato.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Nenhum contrato encontrado para o cliente $clienteId');
        return [];
      }

      return [];
    } on DioException catch (e) {
      debugPrint('❌ Erro ao buscar contratos: ${e.message}');
      if (e.response?.statusCode == 404) {
        return [];
      }
      return [];
    } catch (e) {
      debugPrint('❌ Erro inesperado: $e');
      return [];
    }
  }

  Future<Contrato?> buscarContratoPorNumero(String numeroContrato) async {
    try {
      debugPrint('📋 Buscando contrato: $numeroContrato');
      debugPrint('📍 URL: ${ApiEndpoints.contratos}/$numeroContrato');

      final response = await _dio.get(
        '${ApiEndpoints.contratos}/$numeroContrato',
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 200) {
        return Contrato.fromJson(response.data);
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Contrato $numeroContrato não encontrado');
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar contrato: $e');
      return null;
    }
  }
}
