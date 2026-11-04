import 'package:flutter/material.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';
import '../services/banco_service.dart';
import '../widgets/widgetsImagem.dart';
import 'tela_detalhes.dart';

class TelaLista extends StatefulWidget {
  Usuario usuario;
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
      ),
      body: _lista(),
    );
  }

  _lista() {
    if (_resultsList.isEmpty) {
      return Center(child: Text("Sua lista está vazia"));
    }
    return ListView(
      padding: EdgeInsets.all(9),
      children: [
        for (var titulo in _resultsList)
          ListTile(
            leading: Imagens(titulo.imagem, 60),
            title: Text(titulo.nome),
            subtitle: Text("${titulo.tipo} - ${titulo.situacao}"),
            onTap: () {
              _abreDetalhes(titulo);
            },
          ),
      ],
    );
  }

  Future<void> _abreDetalhes(Titulo titulo) async {
    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return TelaDetalhes(widget.usuario, titulo);
    }));
    _buscaRegistro(); //Mostra as mudanças feitas nos detalhes
  }

  Future<void> _buscaRegistro() async {
    final lista = await _banco.listarTitulos(widget.usuario);
    if (!mounted) return;
    setState(() {
      _resultsList = lista;
    });
  }
}
