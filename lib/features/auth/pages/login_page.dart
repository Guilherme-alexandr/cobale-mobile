import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../widgets/cpf_input.dart';
import '../widgets/password_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _loginController = LoginController();

  bool _loading = false;

  void _realizarLogin() async {
    final cpf = _cpfController.text;
    final senha = _senhaController.text;

    final camposValidos = _loginController.validarCampos(cpf, senha);

    if (!camposValidos) {
      _mostrarErro('Preencha CPF e senha corretamente');
      return;
    }

    setState(() => _loading = true);

    final sucesso = await _loginController.login(cpf, senha);

    setState(() => _loading = false);

    if (sucesso) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _mostrarErro('CPF ou senha inválidos');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CpfInput(controller: _cpfController),
            const SizedBox(height: 12),
            PasswordInput(controller: _senhaController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _realizarLogin,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
