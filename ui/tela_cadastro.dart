import 'package:flutter/material.dart';

import '../services/banco_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsInput.dart';
import '../widgets/widgetsTexto.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final BancoService _banco = BancoService();

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
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Textos("Campos com * são obrigatórios", tamanho: 14),
          SizedBox(height: 8),
          InputTextos("Nome", "Digite seu nome", controller: _nome, obrigatorio: true),
          InputTextos("E-mail", "Digite seu e-mail", controller: _email, obrigatorio: true),
          InputTextos("Senha", "Mínimo de 6 caracteres", controller: _senha, senha: true, obrigatorio: true),
          Botoes("Cadastrar", onPressed: _cadastrar),
        ],
      ),
    );
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _mensagem("Informe um e-mail válido");
      return;
    }
    if (_senha.text.length < 6) {
      _mensagem("A senha deve ter no mínimo 6 caracteres");
      return;
    }
    try {
      await _banco.cadastrarUsuario(_nome.text.trim(), email, _senha.text);
      if (!mounted) return;
      _mensagem("Usuário cadastrado! Faça o login.");
      Navigator.pop(context);
    } catch (e) {
      _mensagem(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  void _mensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }
}
