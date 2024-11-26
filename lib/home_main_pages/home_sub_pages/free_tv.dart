import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Data class to hold episode information
class Episode {
  final String posterUrl;
  final String title;
  final String subtitle;

  Episode({required this.posterUrl, required this.title, required this.subtitle});
}

class FetchMediaData {
  final String apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c'; // Replace with your API Key
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Fetch latest free TV episode data (poster, title, and subtitle)
  Future<List<Episode>> fetchLatestFreeEpisodes() async {
    final response = await http.get(Uri.parse('$baseUrl/tv/popular?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> tvShows = data['results'];
      return tvShows.take(10).map<Episode>((tvShow) {
        final posterPath = tvShow['poster_path'];
        final title = tvShow['name'] ?? 'Unknown Title';
        final subtitle = 'S${tvShow['id']} E1 · ${tvShow['first_air_date'] ?? 'Unknown Date'}';
        return Episode(
          posterUrl: 'https://image.tmdb.org/t/p/w500$posterPath',
          title: title,
          subtitle: subtitle,
        );
      }).toList();
    } else {
      throw Exception('Failed to load latest TV episodes');
    }
  }
}

class FreeTv extends StatefulWidget {
  const FreeTv({Key? key}) : super(key: key);

  @override
  State<FreeTv> createState() => _FreeTvState();
}

class _FreeTvState extends State<FreeTv> {
  late Future<List<Episode>> _episodesFuture;

  @override
  void initState() {
    super.initState();
    _episodesFuture = FetchMediaData().fetchLatestFreeEpisodes(); // Fetch once and cache
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Latest ',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Free ',
                      style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'TV Episodes',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Episode>>(
                future: _episodesFuture, // Use the cached future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load episodes.',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No episodes available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final episodes = snapshot.data!;
                    return SizedBox(
                      height: 210, // Increased height to fit all elements
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: episodes.length,
                        separatorBuilder: (ctx, index) => const SizedBox(width: 10),
                        itemBuilder: (ctx, index) {
                          final episode = episodes[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 160,
                                  height: 120,
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        episode.posterUrl,
                                        fit: BoxFit.cover,
                                        width: 160,
                                        height: 120,
                                      ),
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          color: Colors.blue,
                                          child: const Text(
                                            'FREE',
                                            style: TextStyle(
                                                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        top: 40,
                                        left: 70,
                                        child: Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                episode.title,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                episode.subtitle,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
