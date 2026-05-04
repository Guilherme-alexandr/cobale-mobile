// lib/core/api/api_interceptor.dart

import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorage _storage = SecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Adicionar token se existir
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Tratar erro 401 (token expirado/inválido)
    if (err.response?.statusCode == 401) {
      await _storage.clearAll();
      // Opcional: emitir evento para redirecionar para login
    }
    handler.next(err);
  }
}
