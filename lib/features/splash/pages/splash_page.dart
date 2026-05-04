// lib/features/splash/pages/splash_page.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/login_servico.dart';
import '../../../core/api/api_endpoints.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.wait([
      _wakeUpApi(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    final isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn) {
      await _authService.updateLastActivity();
    }

    if (!mounted) return;

    // 5. Navegação segura e sem chaves aninhadas!
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  Future<void> _wakeUpApi() async {
    try {
      debugPrint('🌐 Acordando a API do Render...');

      final dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final response = await dio.get('/ping');

      debugPrint('✅ API respondendo! Status: ${response.statusCode}');
    } catch (e) {
      debugPrint('⚠️ Erro ao acordar API ou tempo excedido: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/imagens/logo.png',
              height: 120,
              errorBuilder: (_, _, _) => const Icon(
                Icons.attach_money,
                size: 80,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'CobAle',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
