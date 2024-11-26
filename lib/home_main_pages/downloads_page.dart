import 'package:flutter/material.dart';

class Downloads extends StatelessWidget {
  const Downloads({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 17, 17, 17),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text('Downloads',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset('assets/box.jpeg',
              height: 100,
              width: 100,
              ),
            ),
            const Text('No Downloads Available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
            const Text('Explore and download your favourite movies\nand shows to watch on the go',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 172, 171, 171),
            ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(300, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
             child: const Text('Go to Home',
             style: TextStyle(
              color: Colors.black,
              
             ),
             )),
          ],
        ),
      ),
    );
  }
}