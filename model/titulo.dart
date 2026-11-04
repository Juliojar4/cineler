class Titulo {
  static const tipos = ['Filme', 'Série', 'Livro'];
  static const situacoes = ['Quero assistir/ler', 'Acompanhando', 'Finalizado'];

  final int? id; //id no banco local
  final int? usuarioId;
  final String idApi; //id do título na API externa
  final String tipo;
  final String nome;
  final String? descricao;
  final String? imagem;
  final String? info; //ano (filmes/séries) ou autor e ano (livros)
  String situacao;

  Titulo({
    this.id,
    this.usuarioId,
    required this.idApi,
    required this.tipo,
    required this.nome,
    this.descricao,
    this.imagem,
    this.info,
    this.situacao = 'Quero assistir/ler',
  });

  //Resultado da API do TMDB (filmes e séries)
  factory Titulo.fromTmdb(Map<String, dynamic> json) {
    final filme = json['media_type'] == 'movie';
    final String? data = filme ? json['release_date'] : json['first_air_date'];
    final String? poster = json['poster_path'];
    final String? sinopse = json['overview'];
    return Titulo(
      idApi: json['id'].toString(),
      tipo: filme ? 'Filme' : 'Série',
      nome: (filme ? json['title'] : json['name']) ?? 'Sem nome',
      descricao: sinopse?.isNotEmpty ?? false ? sinopse : null,
      imagem: poster != null ? 'https://image.tmdb.org/t/p/w500$poster' : null,
      info: data != null && data.length >= 4 ? data.substring(0, 4) : null,
    );
  }

  //Resultado da API do Open Library (livros)
  factory Titulo.fromOpenLibrary(Map<String, dynamic> json) {
    final List? autores = json['author_name'];
    final ano = json['first_publish_year'];
    final capa = json['cover_i'];
    final partes = [
      if (autores != null && autores.isNotEmpty) autores.join(', '),
      if (ano != null) ano.toString(),
    ];
    return Titulo(
      idApi: json['key'],
      tipo: 'Livro',
      nome: json['title'] ?? 'Sem título',
      imagem: capa != null ? 'https://covers.openlibrary.org/b/id/$capa-L.jpg' : null,
      info: partes.isEmpty ? null : partes.join(' • '),
    );
  }

  Titulo copiaCom({int? id, int? usuarioId, String? descricao}) {
    return Titulo(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      idApi: idApi,
      tipo: tipo,
      nome: nome,
      descricao: descricao ?? this.descricao,
      imagem: imagem,
      info: info,
      situacao: situacao,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'usuario_id': usuarioId,
        'id_api': idApi,
        'tipo': tipo,
        'nome': nome,
        'descricao': descricao,
        'imagem': imagem,
        'info': info,
        'situacao': situacao,
      };

  factory Titulo.fromMap(Map<String, dynamic> map) {
    return Titulo(
      id: map['id'],
      usuarioId: map['usuario_id'],
      idApi: map['id_api'],
      tipo: map['tipo'],
      nome: map['nome'],
      descricao: map['descricao'],
      imagem: map['imagem'],
      info: map['info'],
      situacao: map['situacao'],
    );
  }
}
