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
  Usuario usuario;
  TelaPesquisa(this.usuario);

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  String _textoBotao = "Pesquisar";
  String _tipo = "filmes"; //Resposta do radio
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
      padding: EdgeInsets.all(9),
      children: [
        _radioButton("Filmes e séries", "filmes"),
        _radioButton("Livros", "livros"),
        InputTextos("Nome do título", "Digite o nome", controller: _controllerBusca),
        Botoes(_textoBotao, onPressed: _buscar),
        Text(_aviso),
        for (var titulo in _resultsList)
          ListTile(
            leading: Imagens(titulo.imagem, 60),
            title: Text(titulo.nome),
            subtitle: Text("${titulo.tipo} ${titulo.info ?? ""}"),
            onTap: () {
              _abreOutraTela(context, TelaDetalhes(widget.usuario, titulo));
            },
          ),
      ],
    );
  }

  _radioButton(String texto, String valor) {
    return Row(
      children: <Widget>[
        Textos(texto),
        Radio<String>(
          value: valor,
          groupValue: _tipo,
          onChanged: _radioValueChange,
        ),
      ],
    );
  }

  void _radioValueChange(String? value) {
    setState(() {
      _tipo = value!;
    });
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
