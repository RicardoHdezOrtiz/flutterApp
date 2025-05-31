import 'package:dio/dio.dart';
import 'package:mi_primer_proyecto/utils/actor_model.dart';

final String _apiKey = '705786c29ef416ecf63152888a985cd5';
final String _baseUrl = 'https://api.themoviedb.org/3';
final Dio dio = Dio();

Future<List<ActorModel>> getMovieCast(int movieId) async {
  try {
    final url = '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=es-MX';
    final response = await dio.get(url);
    final castList = response.data['cast'] as List;

    return castList.map((actor) => ActorModel.fromMap(actor)).toList();
  } catch (e) {
    print('Error en getMovieCast: $e');
    return [];
  }
}