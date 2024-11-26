import 'package:flutter/material.dart';
import 'package:hotstar/api/fetch_latest_releases.dart';

class LatestRelease extends StatefulWidget {
  LatestRelease({super.key});

  @override
  State<LatestRelease> createState() => _LatestReleaseState();
}

class _LatestReleaseState extends State<LatestRelease> {
  final ApiServices apiServices = ApiServices();
  List<String> moviePoster = [];
  bool isLoading = true;
  Future<void> fetchMovies() async{
    try{
      final posters = await apiServices.fetchLatestReleases();
      setState(() {
        moviePoster = posters;
        isLoading = false;
      });
    }catch (e) {
      setState(() {
        isLoading = false;
      });
      throw ('Error fetching movies: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Latest Releases',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              isLoading  
              ? const Center(
                child: CircularProgressIndicator(),
              )
              :SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx,index){
                    final posterUrl = 'https://image.tmdb.org/t/p/w500${moviePoster[index]}';
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        width: 110,
                        height: 190,
                        child: Image.network(
                          posterUrl,
                          fit: BoxFit.cover,
                          width: 110,
                          errorBuilder: (ctx,error,stackTrace){
                            return Container(
                              color: Colors.grey,
                              child: const Icon(Icons.broken_image,color: Colors.white),
                            );
                          },
                          )),
                    );
                  },
                  separatorBuilder: (ctx,index){
                    return const SizedBox(width: 5);
                  },
                   itemCount: moviePoster.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}