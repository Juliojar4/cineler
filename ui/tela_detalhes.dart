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
    final cores = Theme.of(context).colorScheme;
    final titulo = widget.titulo;
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Center(child: Imagens(titulo.imagem, 300)),
        SizedBox(height: 20),
        Textos(titulo.nome),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(avatar: Icon(titulo.tipo == "Livro" ? Icons.menu_book : Icons.movie, size: 18), label: Text(titulo.tipo)),
            if (titulo.info != null && titulo.info!.isNotEmpty) Chip(label: Text(titulo.info!)),
          ],
        ),
        SizedBox(height: 16),
        Text(
          titulo.descricao ?? "Descrição não disponível",
          style: TextStyle(height: 1.5, color: cores.onSurfaceVariant),
        ),
        SizedBox(height: 24),
        if (_salvo == null)
          Botoes("Salvar na minha lista", onPressed: _salvar)
        else ...[
          Text("Situação", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var situacao in ["Quero assistir/ler", "Acompanhando", "Finalizado"])
                ChoiceChip(
                  label: Text(situacao),
                  selected: _salvo!.situacao == situacao,
                  onSelected: (_) => _radioValueChange(situacao),
                ),
            ],
          ),
          SizedBox(height: 16),
          Botoes("Remover da minha lista", secundario: true, onPressed: _remover),
        ],
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
