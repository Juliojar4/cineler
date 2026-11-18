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
    final cores = Theme.of(context).colorScheme;
    if (_resultsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 72, color: cores.onSurfaceVariant),
            SizedBox(height: 12),
            Text("Sua lista está vazia", style: TextStyle(color: cores.onSurfaceVariant, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        for (var titulo in _resultsList)
          Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: Imagens(titulo.imagem, 72),
              title: Text(titulo.nome, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text("${titulo.tipo} • ${titulo.situacao}", style: TextStyle(color: cores.primary)),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _abreDetalhes(titulo);
              },
            ),
          ),
      ],
    );
  }

  Future<void> _abreDetalhes(Titulo titulo) async {
    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return TelaDetalhes(widget.usuario, titulo);
    }));
    _buscaRegistro();
  }

  Future<void> _buscaRegistro() async {
    final lista = await _banco.listarTitulos(widget.usuario);
    if (!mounted) return;
    setState(() {
      _resultsList = lista;
    });
  }
}
