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
    return ListView(
      padding: EdgeInsets.all(9),
      children: [
        InputTextos("Nome *", "Digite seu nome", controller: _nome),
        InputTextos("E-mail *", "Digite seu e-mail", controller: _email),
        InputTextos("Senha *", "Digite sua senha", controller: _senha, senha: true),
        Text(_aviso),
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
