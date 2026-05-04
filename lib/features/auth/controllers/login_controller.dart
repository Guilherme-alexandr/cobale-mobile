// lib/features/auth/controllers/login_controller.dart

import 'package:flutter/material.dart';
import '../../../core/services/login_servico.dart';

class LoginController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String cpf, String dataNascimento) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cpfLimpo = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    debugPrint('📱 LoginController - CPF: $cpfLimpo, Data: $dataNascimento');

    final result = await _authService.login(cpfLimpo, dataNascimento);

    debugPrint('📱 Resultado do login: $result');

    _isLoading = false;

    if (result['success'] == true) {
      debugPrint('✅ Login bem sucedido! Indo para Home...');
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error'] ?? 'Erro desconhecido';
      debugPrint('❌ Falha no login: $_errorMessage');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
