// lib/core/storage/secure_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorage {
  static const String _keyToken = 'auth_token';
  static const String _keyClienteId = 'cliente_id';
  static const String _keyClienteNome = 'cliente_nome';
  static const String _keyClienteCpf = 'cliente_cpf';
  static const String _keyClienteEmail = 'cliente_email';
  static const String _keyClienteTelefone = 'cliente_telefone';
  static const String _keyLastActivity = 'last_activity'; // NOVO

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const int _expirationTimeMs = 30 * 60 * 1000; // 30 minutos

  // Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
    await _updateLastActivity();
  }

  Future<String?> getToken() async {
    if (await _isTokenExpired()) {
      await clearAll();
      return null;
    }
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Activity tracking
  Future<void> _updateLastActivity() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _storage.write(key: _keyLastActivity, value: now.toString());
    debugPrint('🕐 Última atividade atualizada: ${DateTime.now()}');
  }

  Future<void> updateLastActivity() async {
    await _updateLastActivity();
  }

  Future<bool> _isTokenExpired() async {
    final lastActivityStr = await _storage.read(key: _keyLastActivity);
    if (lastActivityStr == null) return true;

    final lastActivity = int.tryParse(lastActivityStr) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeSinceLastActivity = now - lastActivity;

    final isExpired = timeSinceLastActivity > _expirationTimeMs;

    if (isExpired) {
      debugPrint(
        '🔒 Token expirado - Inativo por ${timeSinceLastActivity ~/ 60000} minutos',
      );
    } else {
      final remainingMinutes =
          (_expirationTimeMs - timeSinceLastActivity) ~/ 60000;
      debugPrint('🔑 Token válido por mais $remainingMinutes minutos');
    }

    return isExpired;
  }

  // Cliente
  Future<void> saveCliente(Map<String, dynamic> cliente) async {
    await _storage.write(key: _keyClienteId, value: cliente['id'].toString());
    await _storage.write(key: _keyClienteNome, value: cliente['nome']);
    await _storage.write(key: _keyClienteCpf, value: cliente['cpf']);
    await _storage.write(key: _keyClienteEmail, value: cliente['email']);
    await _storage.write(key: _keyClienteTelefone, value: cliente['telefone']);
    await _updateLastActivity(); // Atualiza atividade ao salvar cliente
  }

  Future<Map<String, String?>> getCliente() async {
    return {
      'id': await _storage.read(key: _keyClienteId),
      'nome': await _storage.read(key: _keyClienteNome),
      'cpf': await _storage.read(key: _keyClienteCpf),
      'email': await _storage.read(key: _keyClienteEmail),
      'telefone': await _storage.read(key: _keyClienteTelefone),
    };
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyClienteId);
    await _storage.delete(key: _keyClienteNome);
    await _storage.delete(key: _keyClienteCpf);
    await _storage.delete(key: _keyClienteEmail);
    await _storage.delete(key: _keyClienteTelefone);
    await _storage.delete(key: _keyLastActivity);
    debugPrint('🗑️ Todos os dados de storage foram limpos');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final isLogged = token != null && token.isNotEmpty;
    debugPrint('🔐 Usuário logado: $isLogged');
    return isLogged;
  }
}
