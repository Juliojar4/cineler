import 'package:dio/dio.dart';

import '../model/titulo.dart';

class LivroService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://openlibrary.org",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  //Pesquisa livros pelo título
  Future<List<Titulo>> buscarLivros(String titulo) async {
    try {
      final response = await _dio.get('/search.json', queryParameters: {
        'title': titulo,
        'limit': 20,
        'fields': 'key,title,author_name,first_publish_year,cover_i',
      });

      if (response.statusCode == 200) {
        final List resultados = response.data['docs'];
        return resultados.map((r) => Titulo.fromOpenLibrary(r)).toList();
      } else {
        throw Exception("Erro na requisição");
      }
    } on DioException {
      throw Exception("Serviço de livros indisponível. Verifique sua conexão.");
    }
  }

  //A pesquisa não traz a descrição, então ela é buscada nos detalhes da obra
  Future<String?> buscarDescricao(String key) async {
    try {
      final response = await _dio.get('$key.json');
      final descricao = response.data['description'];
      if (descricao is Map) return descricao['value'];
      return descricao;
    } on DioException {
      return null; //a falta da descrição não impede ver o resto
    }
  }
}
