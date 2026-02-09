class LoginController {
  bool validarCampos(String cpf, String senha) {
    if (cpf.isEmpty || senha.isEmpty) {
      return false;
    }
    if (cpf.length < 11) {
      return false;
    }
    return true;
  }

  Future<bool> login(String cpf, String senha) async {
    // 🔮 FUTURO: chamada real à API
    await Future.delayed(const Duration(seconds: 1));

    // Simulação de login válido
    return cpf == '12345678900' && senha == '123456';
  }
}
