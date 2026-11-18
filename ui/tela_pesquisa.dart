import 'package:flutter/material.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';
import '../services/filme_service.dart';
import '../services/livro_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsImagem.dart';
import '../widgets/widgetsInput.dart';
import 'tela_detalhes.dart';

class TelaPesquisa extends StatefulWidget {
  Usuario usuario;
  TelaPesquisa(this.usuario);

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  String _textoBotao = "Pesquisar";
  String _tipo = "filmes";
  String _aviso = "";
  List<Titulo> _resultsList = [];
  final FilmeService _filmeService = FilmeService();
  final LivroService _livroService = LivroService();
  final TextEditingController _controllerBusca = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesquisar"),
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: "filmes", label: Text("Filmes e séries"), icon: Icon(Icons.movie_outlined)),
            ButtonSegment(value: "livros", label: Text("Livros"), icon: Icon(Icons.menu_book_outlined)),
          ],
          selected: {_tipo},
          onSelectionChanged: (selecao) {
            setState(() {
              _tipo = selecao.first;
            });
          },
        ),
        SizedBox(height: 8),
        InputTextos("Nome do título", "Digite o nome", controller: _controllerBusca, icone: Icons.search),
        Botoes(_textoBotao, onPressed: _buscar),
        if (_aviso.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(_aviso, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        SizedBox(height: 8),
        for (var titulo in _resultsList)
          Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: Imagens(titulo.imagem, 72),
              title: Text(titulo.nome, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${titulo.tipo} • ${titulo.info ?? ""}", maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _abreOutraTela(context, TelaDetalhes(widget.usuario, titulo));
              },
            ),
          ),
      ],
    );
  }

  Future<void> _buscar() async {
    if (_controllerBusca.text.trim().isEmpty) {
      setState(() {
        _aviso = "Digite o nome do título";
      });
      return;
    }
    setState(() {
      _textoBotao = "Pesquisando...";
      _aviso = "";
    });
    try {
      final resultado = _tipo == "filmes"
          ? await _filmeService.buscarFilmesSeries(_controllerBusca.text)
          : await _livroService.buscarLivros(_controllerBusca.text);
      if (!mounted) return;
      setState(() {
        _resultsList = resultado;
        if (resultado.isEmpty) _aviso = "Nenhum título encontrado";
      });
    } catch (e) {
      print("Erro: $e");
      if (!mounted) return;
      setState(() {
        _resultsList = [];
        _aviso = "Serviço indisponível. Verifique sua conexão.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _textoBotao = "Pesquisar";
        });
      }
    }
  }

  _abreOutraTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
