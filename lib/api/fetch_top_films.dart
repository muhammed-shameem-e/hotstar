import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchTopFilms {
  final String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c'; // Replace with your API Key
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<String>> fetchTopMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> movies = data['results'];
      // Extract top 10 movies and map their poster URLs
      return movies.take(10).map<String>((movie) {
        return 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';
      }).toList();
    } else {
      throw Exception('Failed to load top movies');
    }
  }
}
