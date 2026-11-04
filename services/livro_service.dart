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

  Future<List<Titulo>> buscarLivros(String titulo) async {
    try {
      final response = await _dio.get('/search.json', queryParameters: {
        'title': titulo,
        'limit': 20,
        'fields': 'key,title,author_name,cover_i',
      });

      List<Titulo> lista = [];
      for (var item in response.data['docs']) {
        lista.add(Titulo.fromOpenLibrary(item));
      }
      return lista;
    } on DioException catch (e) {
      throw Exception("Erro de conexão: ${e.message}");
    }
  }

  //A pesquisa não traz a descrição, ela vem nos detalhes do livro
  Future<String?> buscarDescricao(String key) async {
    try {
      final response = await _dio.get('$key.json');
      final descricao = response.data['description'];
      return descricao is Map ? descricao['value'] : descricao;
    } on DioException {
      return null;
    }
  }
}
