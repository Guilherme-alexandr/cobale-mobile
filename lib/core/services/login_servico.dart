// lib/core/services/login_servico.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/secure_storage.dart';
import '../routes/app_routes.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;
  final SecureStorage _storage = SecureStorage();

  Future<Map<String, dynamic>> login(String cpf, String dataNascimento) async {
    try {
      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.clienteLogin}';
      debugPrint('🌐 URL completa: $url');
      debugPrint(
        '📦 Payload: {"cpf": "$cpf", "data_nascimento": "$dataNascimento"}',
      );

      final response = await _dio.post(
        ApiEndpoints.clienteLogin,
        data: {'cpf': cpf, 'data_nascimento': dataNascimento},
      );

      debugPrint('📡 Status: ${response.statusCode}');
      debugPrint('📦 Dados: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        await _storage.saveToken(data['token']);
        await _storage.saveCliente(data['cliente']);

        return {'success': true, 'cliente': data['cliente']};
      }

      return {'success': false, 'error': 'Erro ao fazer login'};
    } on DioException catch (e) {
      debugPrint('❌ DioError: $e');

      String errorMessage = 'Erro de conexão';

      if (e.response != null) {
        debugPrint('Status: ${e.response?.statusCode}');
        debugPrint('Resposta: ${e.response?.data}');

        final data = e.response?.data;
        if (data != null && data['erro'] != null) {
          errorMessage = data['erro'];
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'CPF ou data de nascimento inválidos';
        } else if (e.response?.statusCode == 404) {
          errorMessage = 'Cliente não encontrado';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Tempo de conexão esgotado';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Não foi possível conectar ao servidor';
      }

      return {'success': false, 'error': errorMessage};
    } catch (e) {
      debugPrint('❌ Erro inesperado: $e');
      return {'success': false, 'error': 'Erro inesperado. Tente novamente.'};
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  Future<Map<String, String?>> getCliente() async {
    return await _storage.getCliente();
  }

  Future<bool> isTokenValid() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> updateLastActivity() async {
    await _storage.updateLastActivity();
  }

  Future<void> checkAndHandleExpiration(BuildContext context) async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      // Token expirado ou não existe
      await logout();

      // Verifica se a tela ainda existe antes de tentar navegar
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          // Certifique-se de que AppRoutes está importado no topo do arquivo!
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }
} // ✅ A chave final da classe agora engloba todas as funções.
