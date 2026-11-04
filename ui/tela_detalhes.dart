import 'package:flutter/material.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';
import '../services/banco_service.dart';
import '../services/livro_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsImagem.dart';
import '../widgets/widgetsTexto.dart';

class TelaDetalhes extends StatefulWidget {
  final Usuario usuario;
  final Titulo titulo; //título vindo da pesquisa ou da lista
  TelaDetalhes(this.usuario, this.titulo);

  @override
  _TelaDetalhesState createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  final BancoService _banco = BancoService();
  final LivroService _livroService = LivroService();
  late Titulo _titulo;
  Titulo? _salvo; //registro na lista do usuário (null = não salvo)

  @override
  void initState() {
    super.initState();
    _titulo = widget.titulo;
    _carregar();
  }

  Future<void> _carregar() async {
    final salvo = await _banco.buscarTitulo(widget.usuario, _titulo);
    if (!mounted) return;
    setState(() {
      _salvo = salvo;
      if (salvo != null) _titulo = salvo;
    });
    //Livros da pesquisa vêm sem descrição: busca à parte, só se tiver Internet
    if (_titulo.tipo == "Livro" && _titulo.descricao == null) {
      final descricao = await _livroService.buscarDescricao(_titulo.idApi);
      if (descricao != null && mounted) {
        setState(() {
          _titulo = _titulo.copiaCom(descricao: descricao);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo.tipo),
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Center(child: Capa(_titulo.imagem, largura: 180, altura: 270)),
        SizedBox(height: 12),
        Textos(_titulo.nome, tamanho: 24),
        if (_titulo.info != null) Textos(_titulo.info!, tamanho: 16),
        SizedBox(height: 8),
        Textos(_titulo.descricao ?? "Descrição não disponível.", tamanho: 16),
        Divider(height: 32),
        ..._salvo == null ? _naoSalvo() : _jaSalvo(),
      ],
    );
  }

  List<Widget> _naoSalvo() {
    return [Botoes("Salvar na minha lista", onPressed: _salvar)];
  }

  List<Widget> _jaSalvo() {
    return [
      Textos("Situação na minha lista:"),
      RadioGroup<String>(
        groupValue: _salvo!.situacao,
        onChanged: _mudaSituacao,
        child: Column(
          children: Titulo.situacoes
              .map((s) => RadioListTile<String>(value: s, title: Text(s)))
              .toList(),
        ),
      ),
      Botoes("Remover da minha lista", onPressed: _remover),
    ];
  }

  Future<void> _salvar() async {
    try {
      await _banco.salvarTitulo(widget.usuario, _titulo);
      _mensagem("Salvo na sua lista");
    } catch (e) {
      _mensagem(e.toString().replaceFirst("Exception: ", ""));
    }
    _carregar();
  }

  Future<void> _mudaSituacao(String? valor) async {
    _salvo!.situacao = valor!;
    await _banco.atualizarSituacao(widget.usuario, _salvo!);
    setState(() {});
  }

  Future<void> _remover() async {
    await _banco.removerTitulo(widget.usuario, _salvo!);
    _mensagem("Removido da sua lista");
    setState(() {
      _salvo = null;
    });
  }

  void _mensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }
}
