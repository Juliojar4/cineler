import 'package:flutter/material.dart';

import '../model/usuario.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsTexto.dart';
import 'tela_lista.dart';
import 'tela_login.dart';
import 'tela_pesquisa.dart';

class Menu extends StatelessWidget {
  final Usuario usuario; //usuário ativo, repassado para as outras telas
  Menu(this.usuario);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CineLer"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _abreOutraTela(context, TelaPesquisa(usuario));
            },
            tooltip: 'Pesquisar títulos',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _sair(context);
            },
            tooltip: 'Sair',
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Textos("Olá, ${usuario.nome}!", tamanho: 24),
          Textos("O que você quer fazer?", tamanho: 16),
          SizedBox(height: 16),
          Botoes("Pesquisar filmes, séries e livros", onPressed: () {
            _abreOutraTela(context, TelaPesquisa(usuario));
          }),
          Botoes("Minha lista", onPressed: () {
            _abreOutraTela(context, TelaLista(usuario));
          }),
          Botoes("Sair", onPressed: () {
            _sair(context);
          }),
        ],
      ),
    );
  }

  _abreOutraTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  //Volta para o login e limpa as telas abertas
  _sair(ctx) {
    Navigator.pushAndRemoveUntil(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return TelaLogin();
    }), (rota) => false);
  }
}
