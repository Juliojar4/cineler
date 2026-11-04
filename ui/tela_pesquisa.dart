import 'package:flutter/material.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';
import '../services/filme_service.dart';
import '../services/livro_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsImagem.dart';
import '../widgets/widgetsInput.dart';
import '../widgets/widgetsTexto.dart';
import 'tela_detalhes.dart';

class TelaPesquisa extends StatefulWidget {
  final Usuario usuario;
  TelaPesquisa(this.usuario);

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  String _textoBotao = "Pesquisar";
  String _tipo = "filmes"; //resposta do radio: filmes ou livros
  String? _aviso; //mensagem quando não encontra ou dá erro
  List<Titulo> _resultados = [];
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
        _radioButton(),
        InputTextos(_tipo == "filmes" ? "Nome do filme ou série" : "Título do livro", " ",
            controller: _controllerBusca),
        Botoes(_textoBotao, onPressed: _buscar),
        if (_aviso != null) Textos(_aviso!, tamanho: 16),
        ..._resultados.map(_itemResultado),
      ],
    );
  }

  _radioButton() {
    return RadioGroup<String>(
      groupValue: _tipo,
      onChanged: _escolheTipo,
      child: Row(
        children: [
          Expanded(
            child: RadioListTile<String>(
              value: "filmes",
              title: Text("Filmes e séries"),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              value: "livros",
              title: Text("Livros"),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _escolheTipo(String? valor) {
    setState(() {
      _tipo = valor!;
      _resultados = [];
      _aviso = null;
    });
  }

  Widget _itemResultado(Titulo titulo) {
    return Card(
      child: ListTile(
        leading: Capa(titulo.imagem),
        title: Text(titulo.nome),
        subtitle: Text([titulo.tipo, if (titulo.info != null) titulo.info].join(" • ")),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          _abreOutraTela(context, TelaDetalhes(widget.usuario, titulo));
        },
      ),
    );
  }

  Future<void> _buscar() async {
    final texto = _controllerBusca.text.trim();
    if (texto.isEmpty) {
      setState(() {
        _aviso = "Digite o que deseja pesquisar";
      });
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _textoBotao = "Pesquisando...";
      _aviso = null;
    });
    try {
      final resultado = _tipo == "filmes"
          ? await _filmeService.buscarFilmesSeries(texto)
          : await _livroService.buscarLivros(texto);
      setState(() {
        _resultados = resultado;
        if (resultado.isEmpty) _aviso = "Nenhum título encontrado";
      });
    } catch (e) {
      setState(() {
        _resultados = [];
        _aviso = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      setState(() {
        _textoBotao = "Pesquisar";
      });
    }
  }

  _abreOutraTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
