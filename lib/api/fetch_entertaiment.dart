import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchEntertainment {
  final String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c'; // Replace with your API Key
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<String>> fetchEntertainmentData() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> movies = data['results'];

      // Map to a list of poster URLs
      return movies.map<String>((movie) {
        return 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';
      }).toList();
    } else {
      throw Exception('Failed to load entertainment data');
    }
  }
}
