// lib/core/services/cliente_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class ClienteService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>?> buscarClientePorId(int id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.clientes}/$id');

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar cliente: $e');
      return null;
    }
  }
}
