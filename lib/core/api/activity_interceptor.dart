// lib/core/api/activity_interceptor.dart

import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ActivityInterceptor extends Interceptor {
  final SecureStorage _storage = SecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Atualiza atividade a cada requisição
    _storage.updateLastActivity();
    handler.next(options);
  }
}
