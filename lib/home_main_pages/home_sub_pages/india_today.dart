import 'package:flutter/material.dart';
import 'package:hotstar/api/fetch_top_films.dart';

class IndiaToday extends StatefulWidget {
  IndiaToday({super.key});

  @override
  State<IndiaToday> createState() => _IndiaTodayState();
}

class _IndiaTodayState extends State<IndiaToday> {
  final FetchTopFilms fetchTopFilms = FetchTopFilms();
  List<String> moviePoster = [];
  bool isLoading = true;
  Future<void> fetchMovies()async{
    try{
      final posters = await fetchTopFilms.fetchTopMovies();
      setState(() {
        moviePoster = posters;
        isLoading = false;
      });
    }catch (e){
      setState(() {
        isLoading = false;
      });
      throw Exception('failed to load movies');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMovies();
  }
  final List<String> laguages = ['English','Malayalam','hindi','urdu','tamil','arabic'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top 10 India Today',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx,index){
                    return ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 35, 35),
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: Text(
                      laguages[index],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 209, 209, 209),
                      ),
                    ));
                    
                  }, 
                  separatorBuilder: (ctx,index){
                    return const SizedBox(width: 5);
                  },
                   itemCount: 6),
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
                    final posterUrl = moviePoster[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        width: 110,
                        height: 190,
                        child: Image.network(
                          posterUrl,
                          fit: BoxFit.cover,
                          width: 110,
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