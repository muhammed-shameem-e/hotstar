import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchMovieData {
  final String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c'; // Replace with your API Key
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Function to fetch newly added movies
  Future<List<Map<String, dynamic>>> fetchNewlyAddedMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey&language=en-US&page=1'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> movies = data['results'];

      // Extract relevant details for the movies
      return movies.map<Map<String, dynamic>>((movie) {
        return {
          'posterUrl': 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
          'title': movie['title'],
          'releaseDate': movie['release_date'],
          'overview': movie['overview'],
          'rating': movie['vote_average'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load newly added movies');
    }
  }
}

class NewPage extends StatelessWidget {
  const NewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FetchMovieData().fetchNewlyAddedMovies(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final movieList = snapshot.data ?? [];

          return ListView.separated(
            itemCount: movieList.length,
            itemBuilder: (ctx, index) {
              final movie = movieList[index];

              return Container(
                color: const Color.fromARGB(255, 31, 30, 30),
                height: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: Image.network(
                        movie['posterUrl'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: movie['overview'].length > 100
                            ? movie['overview'].substring(0, 100) + '...'
                            : movie['overview'],
                        style: const TextStyle(
                          color: Color.fromARGB(255, 128, 128, 128),
                        ),
                        children: [
                          const TextSpan(
                            text: 'See More',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(270, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 25,
                              ),
                              Text(
                                index % 2 == 0 ? 'Watch Now' : 'Watch For Free',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(60, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(height: 20);
            },
          );
        },
      ),
    );
  }
}
