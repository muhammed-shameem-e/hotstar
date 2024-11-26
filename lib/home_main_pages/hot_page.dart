import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HotPage extends StatefulWidget {
  HotPage({super.key});

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  final String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c'; // Replace with your TMDB API Key
  final String baseUrl = 'https://api.themoviedb.org/3';
  late Future<List<Map<String, dynamic>>> comingSoonMovies;

  // Function to fetch coming soon movies
  Future<List<Map<String, dynamic>>> fetchComingSoonMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey&language=en-US&page=1'));
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
        };
      }).toList();
    } else {
      throw Exception('Failed to load coming soon movies');
    }
  }

  @override
  void initState() {
    super.initState();
    comingSoonMovies = fetchComingSoonMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: comingSoonMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load movies: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            final movies = snapshot.data ?? [];
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final movie = movies[index];
                return Container(
                  color: const Color.fromARGB(255, 31, 30, 30),
                  height: 380,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          movie['posterUrl'] ?? '',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '  Releasing on ${movie['releaseDate']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: "  ${movie['overview']?.substring(0, 50) ?? ''}...",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                          children: [
                            const TextSpan(
                              text: ' See More',
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(225, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_outlined,
                                color: Colors.black,
                                size: 25,
                              ),
                              const Text(
                                'Remind Me',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                movie['releaseDate'] ?? '',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 128, 128, 128),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(height: 20);
              },
              itemCount: movies.length,
            );
          }
        },
      ),
    );
  }
}
