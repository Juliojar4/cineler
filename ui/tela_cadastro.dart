import 'package:flutter/material.dart';

import '../services/banco_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsInput.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final BancoService _banco = BancoService();
  String _aviso = "Campos com * são obrigatórios";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar usuário"),
      ),
      body: _body(),
    );
  }

  _body() {
    final cores = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Icon(Icons.person_add_alt_1_rounded, size: 72, color: cores.primary),
        SizedBox(height: 24),
        InputTextos("Nome *", "Digite seu nome", controller: _nome, icone: Icons.person_outline),
        InputTextos("E-mail *", "Digite seu e-mail", controller: _email, icone: Icons.email_outlined),
        InputTextos("Senha *", "Digite sua senha", controller: _senha, senha: true, icone: Icons.lock_outline),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(_aviso, textAlign: TextAlign.center, style: TextStyle(color: cores.onSurfaceVariant)),
        ),
        Botoes("Cadastrar", onPressed: _cadastrar),
      ],
    );
  }

  Future<void> _cadastrar() async {
    final email = _email.text.trim();
    if (_nome.text.trim().isEmpty || email.isEmpty || _senha.text.isEmpty) {
      setState(() {
        _aviso = "Preencha os campos obrigatórios";
      });
      return;
    }
    if (!email.contains("@")) {
      setState(() {
        _aviso = "Informe um e-mail válido";
      });
      return;
    }
    final cadastrou = await _banco.cadastrarUsuario(_nome.text.trim(), email, _senha.text);
    setState(() {
      _aviso = cadastrou ? "Usuário cadastrado! Volte e faça o login." : "Já existe um usuário com este e-mail";
    });
  }
}
