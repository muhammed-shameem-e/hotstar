import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices{
  final String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c';
  final String bseUrl = 'https://api.themoviedb.org/3';

  Future<List<String>> fetchLatestReleases() async{
    final response = await http.get(Uri.parse('$bseUrl/movie/popular?api_key=$apiKey'));
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final List<dynamic> movies = data['results'];
      return movies.map<String>((movie) => movie['poster_path']).toList();
    }else{
      throw Exception('failed to load movies');
    }
  }
}