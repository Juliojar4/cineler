import 'package:flutter/material.dart';

import '../services/banco_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsInput.dart';
import '../widgets/widgetsTexto.dart';
import 'menu.dart';
import 'tela_cadastro.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final BancoService _banco = BancoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CineLer - Entrar"),
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
          Icon(Icons.movie_filter, size: 80, color: Theme.of(context).colorScheme.primary),
          Textos("Seus filmes, séries e livros em um só lugar.", tamanho: 16),
          SizedBox(height: 16),
          InputTextos("E-mail", "Digite seu e-mail", controller: _email, obrigatorio: true),
          InputTextos("Senha", "Digite sua senha", controller: _senha, senha: true, obrigatorio: true),
          Botoes("Entrar", onPressed: _entrar),
          TextButton(
            onPressed: () {
              _abreOutraTela(context, TelaCadastro());
            },
            child: Text("Não tem conta? Cadastre-se"),
          ),
        ],
      ),
    );
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    final usuario = await _banco.entrar(_email.text.trim(), _senha.text);
    if (!mounted) return;
    if (usuario == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("E-mail ou senha inválidos")));
      return;
    }
    _senha.clear();
    //Substitui a tela de login, assim o "voltar" não retorna para ela
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return Menu(usuario);
    }));
  }

  _abreOutraTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
