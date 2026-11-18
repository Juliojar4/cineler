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
      body: SafeArea(child: _body()),
    );
  }

  _body() {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 64, 24, 24),
      children: [
        Icon(Icons.movie_filter_rounded, size: 88, color: cores.primary),
        SizedBox(height: 12),
        Text("CineLer", textAlign: TextAlign.center, style: textos.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
        Text("Filmes, séries e livros em um só lugar", textAlign: TextAlign.center, style: textos.bodyLarge?.copyWith(color: cores.onSurfaceVariant)),
        SizedBox(height: 40),
        InputTextos("E-mail *", "Digite seu e-mail", controller: _email, icone: Icons.email_outlined),
        InputTextos("Senha *", "Digite sua senha", controller: _senha, senha: true, icone: Icons.lock_outline),
        if (_aviso.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(_aviso, textAlign: TextAlign.center, style: TextStyle(color: cores.error)),
          ),
        SizedBox(height: 8),
        Botoes("Entrar", onPressed: _entrar),
        Botoes("Criar conta", secundario: true, onPressed: () {
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
