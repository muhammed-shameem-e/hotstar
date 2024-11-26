import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

// Function to fetch all movie posters and titles
Future<List<Map<String, String>>> fetchAllMovies() async {
  const String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c'; // Replace with your TMDB API Key
  const String baseUrl = 'https://api.themoviedb.org/3';

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> movies = data['results'];

      // Extract movie titles and poster URLs
      return movies
          .where((movie) => movie['poster_path'] != null)
          .map<Map<String, String>>((movie) => {
                'title': movie['title'] ?? '',
                'posterUrl':
                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              })
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

// Main Search Widget
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<String> languages = [
    'English',
    'Malayalam',
    'Hindi',
    'Urdu',
    'Tamil',
    'Arabic'
  ];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> allMovies = [];
  List<Map<String, String>> filteredMovies = [];
  bool isLoading = true;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      final List<Map<String, String>> movies = await fetchAllMovies();
      setState(() {
        allMovies = movies;
        filteredMovies = movies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching movies: $e');
    }
  }

  void _filterMovies(String query) {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredMovies = allMovies
            .where((movie) =>
                movie['title']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          "Search Movies",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _searchController,
              onChanged: _filterMovies,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 30),
                suffixIcon: const Icon(Icons.mic, size: 30),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Movies, shows, and more',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 77, 76, 76),
                  fontSize: 17,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 35, 35),
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      languages[index],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 209, 209, 209),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(width: 5);
                },
                itemCount: languages.length,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : filteredMovies.isEmpty
                      ? const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : GridView.custom(
                          gridDelegate: SliverQuiltedGridDelegate(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            repeatPattern: QuiltedGridRepeatPattern.same,
                            pattern: [
                              const QuiltedGridTile(1, 1),
                              const QuiltedGridTile(1, 1),
                            ],
                          ),
                          childrenDelegate: SliverChildBuilderDelegate(
                            (ctx, index) {
                              final movie = filteredMovies[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  movie['posterUrl']!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                            childCount: filteredMovies.length,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
