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
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Clique para sair',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Textos("Olá, ${usuario.nome}!"),
          Text("O que vamos fazer hoje?", style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          SizedBox(height: 24),
          _opcao(context, Icons.search_rounded, "Pesquisar", "Encontre filmes, séries e livros", TelaPesquisa(usuario)),
          _opcao(context, Icons.bookmarks_rounded, "Minha lista", "Acompanhe o que você salvou", TelaLista(usuario)),
        ],
      ),
    );
  }

  _opcao(BuildContext context, IconData icone, String titulo, String subtitulo, Widget tela) {
    final cores = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: cores.primaryContainer,
          child: Icon(icone, color: cores.onPrimaryContainer),
        ),
        title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitulo),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          _abreOutraTela(context, tela);
        },
      ),
    );
  }

  _abreOutraTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
