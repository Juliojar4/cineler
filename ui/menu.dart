import 'package:flutter/material.dart';

import '../model/usuario.dart';
import '../widgets/widgetsTexto.dart';
import 'tela_lista.dart';
import 'tela_pesquisa.dart';

class Menu extends StatelessWidget {
  Usuario usuario;
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
            tooltip: 'Clique para pesquisar títulos',
          ),
          IconButton(
            icon: Icon(Icons.line_style),
            onPressed: () {
              _abreOutraTela(context, TelaLista(usuario));
            },
            tooltip: 'Clique para visualizar sua lista',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context); //Sair: volta para o login
            },
            tooltip: 'Clique para sair',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(9),
        children: [
          Textos("Olá, ${usuario.nome}!"),
          Text("Use os botões acima para pesquisar, ver sua lista ou sair."),
        ],
      ),
    );
  }

  _abreOutraTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
