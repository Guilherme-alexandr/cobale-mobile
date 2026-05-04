// lib/core/services/details_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../../features/detalhes/models/bill_model.dart';

class DetailsService {
  final Dio _dio = ApiClient().dio;

  Future<Bill?> buscarAcordoPorId(int id) async {
    try {
      debugPrint('🔍 Buscando acordo ID: $id');

      final response = await _dio.get('${ApiEndpoints.acordos}/$id');

      if (response.statusCode == 200) {
        debugPrint('✅ Acordo encontrado');
        return Bill.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar acordo: $e');
      return null;
    }
  }
}
