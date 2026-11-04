import 'package:dio/dio.dart';

import '../model/titulo.dart';

class FilmeService {
  final String _apiKey = "3502b0392efe92a8d258ae732c11f5e1";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Titulo>> buscarFilmesSeries(String nome) async {
    try {
      final response = await _dio.get('/search/multi', queryParameters: {
        'api_key': _apiKey,
        'query': nome,
        'language': 'pt-BR',
      });

      List<Titulo> lista = [];
      for (var item in response.data['results']) {
        if (item['media_type'] == 'movie' || item['media_type'] == 'tv') {
          lista.add(Titulo.fromTmdb(item));
        }
      }
      return lista;
    } on DioException catch (e) {
      throw Exception("Erro de conexão: ${e.message}");
    }
  }
}
