import 'package:flutter/material.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';
import '../services/banco_service.dart';
import '../services/livro_service.dart';
import '../widgets/widgetsButton.dart';
import '../widgets/widgetsImagem.dart';
import '../widgets/widgetsTexto.dart';

class TelaDetalhes extends StatefulWidget {
  Usuario usuario;
  Titulo titulo;
  TelaDetalhes(this.usuario, this.titulo);

  @override
  _TelaDetalhesState createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  final BancoService _banco = BancoService();
  final LivroService _livroService = LivroService();
  Titulo? _salvo;

  @override
  void initState() {
    super.initState();
    _buscaRegistro();
    _buscaDescricao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo.tipo),
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(9),
      children: [
        Imagens(widget.titulo.imagem, 270),
        Textos(widget.titulo.nome),
        Text(widget.titulo.info ?? ""),
        Text(widget.titulo.descricao ?? "Descrição não disponível"),
        if (_salvo == null)
          Botoes("Salvar na minha lista", onPressed: _salvar)
        else ...[
          _radioButton("Quero assistir/ler"),
          _radioButton("Acompanhando"),
          _radioButton("Finalizado"),
          Botoes("Remover da minha lista", onPressed: _remover),
        ],
      ],
    );
  }

  _radioButton(String situacao) {
    return Row(
      children: <Widget>[
        Text(situacao),
        Radio<String>(
          value: situacao,
          groupValue: _salvo!.situacao,
          onChanged: _radioValueChange,
        ),
      ],
    );
  }

  Future<void> _radioValueChange(String? value) async {
    _salvo!.situacao = value!;
    await _banco.atualizarSituacao(_salvo!);
    setState(() {});
  }

  Future<void> _buscaRegistro() async {
    final salvo = await _banco.buscarTitulo(widget.usuario, widget.titulo);
    if (!mounted) return;
    setState(() {
      _salvo = salvo;
    });
  }

  Future<void> _buscaDescricao() async {
    if (widget.titulo.tipo != "Livro" || widget.titulo.descricao != null) return;
    final descricao = await _livroService.buscarDescricao(widget.titulo.idApi);
    if (!mounted) return;
    setState(() {
      widget.titulo.descricao = descricao;
    });
  }

  Future<void> _salvar() async {
    await _banco.salvarTitulo(widget.usuario, widget.titulo);
    _buscaRegistro();
  }

  Future<void> _remover() async {
    await _banco.removerTitulo(_salvo!);
    setState(() {
      _salvo = null;
    });
  }
}
