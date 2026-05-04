import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../controllers/login_controller.dart';
import '../../../core/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _controller = LoginController();
  final _formKey = GlobalKey<FormState>();

  late final MaskedTextController _cpfController;
  late final MaskedTextController _dataNascimentoController;

  @override
  void initState() {
    super.initState();
    _cpfController = MaskedTextController(mask: '000.000.000-00');
    _dataNascimentoController = MaskedTextController(mask: '00/00/0000');
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _converterDataParaAPI(String data) {
    if (data.length != 10) return '';
    final partes = data.split('/');
    if (partes.length != 3) return '';
    return '${partes[2]}-${partes[1]}-${partes[0]}';
  }

  bool _validarData(String data) {
    if (data.length != 10) return false;
    final partes = data.split('/');
    if (partes.length != 3) return false;

    try {
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);

      if (ano < 1900 || ano > DateTime.now().year) return false;
      if (mes < 1 || mes > 12) return false;
      if (dia < 1 || dia > 31) return false;

      final ultimoDia = DateTime(ano, mes + 1, 0).day;
      if (dia > ultimoDia) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final dataConvertida = _converterDataParaAPI(
        _dataNascimentoController.text,
      );

      // Desativa o teclado para não atrapalhar a visualização do loading
      FocusScope.of(context).unfocus();

      final success = await _controller.login(
        _cpfController.text,
        dataConvertida,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              // 🔥 AQUI ESTÁ A MÁGICA: O ListenableBuilder faz a tela escutar o controller!
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        'lib/imagens/logo.png',
                        height: 120,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.attach_money,
                          size: 80,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Título
                      const Text(
                        'CobAle',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Acesse sua conta',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 48),

                      // Campo CPF
                      TextFormField(
                        controller: _cpfController,
                        keyboardType: TextInputType.number,
                        // Desabilita o campo enquanto estiver carregando
                        enabled: !_controller.isLoading,
                        decoration: InputDecoration(
                          labelText: 'CPF',
                          hintText: '000.000.000-00',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'CPF é obrigatório';
                          }
                          final cpfLimpo = value.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          if (cpfLimpo.length != 11) {
                            return 'CPF inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Data de Nascimento
                      TextFormField(
                        controller: _dataNascimentoController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        // Desabilita o campo enquanto estiver carregando
                        enabled: !_controller.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento',
                          hintText: 'DD/MM/AAAA',
                          prefixIcon: const Icon(Icons.cake),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Data de nascimento é obrigatória';
                          }
                          if (!_validarData(value)) {
                            return 'Data inválida (use DD/MM/AAAA)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Mensagem de erro dinâmica
                      if (_controller.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _controller.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Botão Login
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          // Se estiver carregando, o botão fica inativo (null)
                          onPressed: _controller.isLoading
                              ? null
                              : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // Muda a cor quando desabilitado para dar feedback visual
                            disabledBackgroundColor: const Color(
                              0xFF2196F3,
                            ).withValues(alpha: 0.6),
                          ),
                          // 🔥 AQUI ESTÁ A ANIMAÇÃO DO CÍRCULO
                          child: _controller.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
