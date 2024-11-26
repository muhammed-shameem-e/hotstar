import 'dart:convert';
import 'package:http/http.dart' as http;
Future<List<Map<String, String>>> fetchAllMoviePosters() async {
  const String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c'; // Replace with your TMDB API Key
  const String baseUrl = 'https://api.themoviedb.org/3';

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> movies = data['results'];

      // Return a list of maps with title and poster URL
      return movies
          .map<Map<String, String>>(
            (movie) => {
              'title': movie['title'] ?? '',
              'posterUrl': movie['poster_path'] != null
                  ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                  : '',
            },
          )
          .where((movie) => movie['posterUrl']!.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load movie posters');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
