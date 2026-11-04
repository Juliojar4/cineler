import 'package:dio/dio.dart';

import '../model/titulo.dart';

class FilmeService {
  //Chave gratuita: crie uma conta em https://www.themoviedb.org/settings/api
  static const _apiKey = String.fromEnvironment('TMDB_KEY', defaultValue: '3502b0392efe92a8d258ae732c11f5e1');

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  //Pesquisa filmes e séries pelo nome
  Future<List<Titulo>> buscarFilmesSeries(String nome) async {
    try {
      final response = await _dio.get('/search/multi', queryParameters: {
        'api_key': _apiKey,
        'query': nome,
        'language': 'pt-BR',
      });

      if (response.statusCode == 200) {
        final List resultados = response.data['results'];
        return resultados
            .where((r) => r['media_type'] == 'movie' || r['media_type'] == 'tv')
            .map((r) => Titulo.fromTmdb(r))
            .toList();
      } else {
        throw Exception("Erro na requisição");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Chave da API de filmes inválida");
      }
      throw Exception("Serviço de filmes indisponível. Verifique sua conexão.");
    }
  }
}
