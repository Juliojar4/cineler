import 'package:flutter/material.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';
import '../services/banco_service.dart';
import '../widgets/widgetsImagem.dart';
import '../widgets/widgetsTexto.dart';
import 'tela_detalhes.dart';

class TelaLista extends StatefulWidget {
  final Usuario usuario;
  TelaLista(this.usuario);

  @override
  _TelaListaState createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  final BancoService _banco = BancoService();
  List<Titulo> _resultsList = [];

  @override
  void initState() {
    super.initState();
    _buscaRegistro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha lista"),
        actions: [
          IconButton(
            onPressed: _buscaRegistro,
            icon: Icon(Icons.refresh),
            tooltip: 'Atualizar',
          )
        ],
      ),
      body: _lista(),
    );
  }

  _lista() {
    if (_resultsList.isEmpty) {
      return Center(child: Textos("Sua lista está vazia.\nPesquise e salve títulos!"));
    }
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: _resultsList.length,
      itemBuilder: (context, i) {
        final titulo = _resultsList[i];
        return Card(
          child: ListTile(
            leading: Capa(titulo.imagem),
            title: Text(titulo.nome),
            subtitle: Text("${titulo.tipo} • ${titulo.situacao}"),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return TelaDetalhes(widget.usuario, titulo);
              }));
              _buscaRegistro(); //reflete alterações de situação/remoção
            },
          ),
        );
      },
    );
  }

  Future<void> _buscaRegistro() async {
    final lista = await _banco.listarTitulos(widget.usuario);
    if (!mounted) return;
    setState(() {
      _resultsList = lista;
    });
  }
}
