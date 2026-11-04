import 'package:flutter/material.dart';

import '../services/banco_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsInput.dart';
import 'menu.dart';
import 'tela_cadastro.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final BancoService _banco = BancoService();
  String _aviso = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CineLer"),
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(9),
      children: [
        InputTextos("E-mail *", "Digite seu e-mail", controller: _email),
        InputTextos("Senha *", "Digite sua senha", controller: _senha, senha: true),
        Text(_aviso),
        Botoes("Entrar", onPressed: _entrar),
        Botoes("Cadastrar", onPressed: () {
          _abreOutraTela(context, TelaCadastro());
        }),
      ],
    );
  }

  Future<void> _entrar() async {
    if (_email.text.trim().isEmpty || _senha.text.isEmpty) {
      setState(() {
        _aviso = "Preencha os campos obrigatórios";
      });
      return;
    }
    final usuario = await _banco.entrar(_email.text.trim(), _senha.text);
    if (usuario == null) {
      setState(() {
        _aviso = "E-mail ou senha inválidos";
      });
      return;
    }
    setState(() {
      _aviso = "";
      _senha.text = "";
    });
    if (!mounted) return;
    _abreOutraTela(context, Menu(usuario));
  }

  _abreOutraTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
