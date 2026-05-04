// lib/core/services/acordo_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../../features/detalhes/models/bill_model.dart';

class AcordoService {
  final Dio _dio = ApiClient().dio;

  Future<List<Bill>> buscarAcordosPorCliente(int clienteId) async {
    try {
      debugPrint('📋 Buscando acordos do cliente $clienteId');
      debugPrint('📍 URL: ${ApiEndpoints.acordosPorCliente}/$clienteId');

      final response = await _dio.get(
        '${ApiEndpoints.acordosPorCliente}/$clienteId',
        options: Options(
          validateStatus: (status) =>
              status! < 500, // Aceita 404 sem lançar erro
          sendTimeout: const Duration(
            seconds: 10,
          ), // ✅ ADICIONADO: timeout de envio
          receiveTimeout: const Duration(
            seconds: 10,
          ), // ✅ ADICIONADO: timeout de recebimento
        ),
      );

      debugPrint('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data;
        if (response.data is Map && response.data['acordos'] != null) {
          data = response.data['acordos'];
        } else if (response.data is List) {
          data = response.data;
        } else {
          data = [];
        }

        debugPrint('✅ Acordos encontrados: ${data.length}');
        return data.map((json) => Bill.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Nenhum acordo encontrado para o cliente $clienteId');
        return [];
      }

      return [];
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        debugPrint('⏰ Timeout na conexão ao buscar acordos');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        debugPrint('⏰ Timeout no recebimento ao buscar acordos');
      } else {
        debugPrint('❌ Erro ao buscar acordos: ${e.message}');
      }

      if (e.response?.statusCode == 404) {
        return [];
      }
      return [];
    } catch (e) {
      debugPrint('❌ Erro inesperado ao buscar acordos: $e');
      return [];
    }
  }

  Future<Bill?> buscarAcordoPorId(int id) async {
    try {
      debugPrint('🔍 Buscando acordo ID: $id');
      debugPrint('📍 URL: ${ApiEndpoints.acordos}/$id');

      final response = await _dio.get(
        '${ApiEndpoints.acordos}/$id',
        options: Options(
          validateStatus: (status) => status! < 500,
          sendTimeout: const Duration(seconds: 10), // ✅ ADICIONADO
          receiveTimeout: const Duration(seconds: 10), // ✅ ADICIONADO
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Acordo ID $id encontrado');
        return Bill.fromJson(response.data);
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Acordo ID $id não encontrado');
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        debugPrint('⏰ Timeout na conexão ao buscar acordo ID $id');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        debugPrint('⏰ Timeout no recebimento ao buscar acordo ID $id');
      } else {
        debugPrint('❌ Erro ao buscar acordo por ID: ${e.message}');
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erro inesperado ao buscar acordo: $e');
      return null;
    }
  }
}
