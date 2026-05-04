// lib/core/api/api_client.dart

import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'api_interceptor.dart';
import 'activity_interceptor.dart';

class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Adicionar interceptors
    _dio.interceptors.add(ApiInterceptor());
    _dio.interceptors.add(ActivityInterceptor()); // NOVO
  }

  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;
}
