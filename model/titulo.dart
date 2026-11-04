class Titulo {
  final int? id; //id no banco
  final String idApi; //id na API externa
  final String tipo; //Filme, Série ou Livro
  final String nome;
  String? descricao;
  final String? imagem;
  final String? info; //ano (filmes e séries) ou autor (livros)
  String situacao;

  Titulo({
    this.id,
    required this.idApi,
    required this.tipo,
    required this.nome,
    this.descricao,
    this.imagem,
    this.info,
    this.situacao = 'Quero assistir/ler',
  });

  //Dados vindos da API de filmes e séries (TMDB)
  factory Titulo.fromTmdb(Map<String, dynamic> json) {
    bool filme = json['media_type'] == 'movie';
    String? data = filme ? json['release_date'] : json['first_air_date'];
    return Titulo(
      idApi: json['id'].toString(),
      tipo: filme ? 'Filme' : 'Série',
      nome: (filme ? json['title'] : json['name']) ?? 'Sem nome',
      descricao: json['overview'],
      imagem: json['poster_path'] == null ? null : 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      info: data?.split('-').first,
    );
  }

  //Dados vindos da API de livros (Open Library)
  factory Titulo.fromOpenLibrary(Map<String, dynamic> json) {
    return Titulo(
      idApi: json['key'],
      tipo: 'Livro',
      nome: json['title'] ?? 'Sem título',
      imagem: json['cover_i'] == null ? null : 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg',
      info: json['author_name']?.join(', '),
    );
  }

  //Dados vindos do banco
  factory Titulo.fromMap(Map<String, dynamic> map) {
    return Titulo(
      id: map['id'],
      idApi: map['id_api'],
      tipo: map['tipo'],
      nome: map['nome'],
      descricao: map['descricao'],
      imagem: map['imagem'],
      info: map['info'],
      situacao: map['situacao'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id_api': idApi,
    'tipo': tipo,
    'nome': nome,
    'descricao': descricao,
    'imagem': imagem,
    'info': info,
    'situacao': situacao,
  };
}
