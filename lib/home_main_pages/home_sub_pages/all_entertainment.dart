import 'package:flutter/material.dart';
import 'package:hotstar/api/fetch_entertaiment.dart';

class AllEntertainment extends StatefulWidget {
  const AllEntertainment({super.key});

  @override
  State<AllEntertainment> createState() => _AllEntertainmentState();
}

class _AllEntertainmentState extends State<AllEntertainment> {
  final FetchEntertainment apiServices = FetchEntertainment();
  List<String> moviePoster = [];
  bool isLoading = true;

  Future<void> fetchEntertainment() async {
    try {
      final data = await apiServices.fetchEntertainmentData();
      setState(() {
        moviePoster = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching entertainment data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEntertainment();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Entertainment All-Rounders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          final item = moviePoster[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              width: 110,
                              height: 190,
                              child: Image.network(
                                item,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) => const SizedBox(width: 5),
                        itemCount: moviePoster.length,
                      ),
                    ),
                  ),
                   const SizedBox(height: 10),
            Container(
              height: 275,
              width: double.infinity,
              color: const Color.fromARGB(255, 14, 14, 14),
              child:  Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ClipRRect(
                       borderRadius: BorderRadius.circular(20),
                       child: Image.asset(
                        'assets/download.jpeg',
                        height: 200,
                        width: double.infinity,
                        ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset('assets/logo.jpeg',
                          height: 50,
                          width: 50,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Starwars',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              ),
                            Text(
                              'Streaming from Nov 29',
                              style: TextStyle(
                               color: Color.fromARGB(255, 90, 85, 85),
                              ),
                              ),
                          ],
                        ),
                        const Spacer(),
                       ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 35, 35),
                      minimumSize: const Size(75, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: const Text(
                      'Teaser',
                      style: TextStyle(
                        color: Color.fromARGB(255, 209, 209, 209),
                      ),
                    )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
