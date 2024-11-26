import 'dart:convert';
import 'package:hotstar/api/model_classes.dart/popular_movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hotstar/home_main_pages/home_sub_pages/all_entertainment.dart';
import 'package:hotstar/home_main_pages/home_sub_pages/free_tv.dart';
import 'package:hotstar/home_main_pages/home_sub_pages/india_today.dart';
import 'package:hotstar/home_main_pages/home_sub_pages/latest_release.dart';

// Fetch popular movies
class FetchPopulerMovie {
  static const String _apiKey = '5415ea4d2c0d1f8d3363b33e16d2930c';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<PopularMovie>> fetchPopularMovies() async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List movies = data['results'];

      return movies.map((movie) => PopularMovie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

// Home page with carousel and movies
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PopularMovie> popularMovies = [];
  bool isLoading = true;
  int _currentIndex = 0;

  Future<void> fetchMovies() async {
    try {
      final movies = await FetchPopulerMovie.fetchPopularMovies();
      setState(() {
        popularMovies = movies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching movies $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Carousel with popular movie posters
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        CarouselSlider(
                          items: popularMovies.map((movie) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 300.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            autoPlayInterval: const Duration(seconds: 2),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                        // Dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(popularMovies.length, (index) {
                            return Container(
                              width: _currentIndex == index ? 10.0 : 5.0,
                              height: _currentIndex == index ? 10.0 : 5.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.white // Active dot color
                                    : Colors.grey, // Inactive dot color
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
              const SizedBox(height: 10),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 35, 35),
                      minimumSize: const Size(175, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white),
                          Text(
                            'Watch ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Free',
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 36, 35, 35),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Other sections
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 230),
                child: LatestRelease(),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 290),
                child: IndiaToday(),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 525),
                child: AllEntertainment(),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: FreeTv(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
