import 'package:flutter/material.dart';

class MySpace extends StatelessWidget {
  const MySpace({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
       body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:[
              Color.fromARGB(255, 0, 18, 61),
              Colors.black,
            ] 
            ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/remover.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.settings,color: Colors.white,),
                  const Text(' Help & Settings',
                  style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ClipRRect(
              child: Image.asset(
                'assets/secondbox.png',
                ),
            ),
            const Text('Login to Disney+ Hotstar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
            const Text(
              'Start Watching from where you let off, personlise for\nkids and more',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 172, 171, 171),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(200, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
             child: const Text(
              'Log In',
              style: TextStyle(
                color:Colors.white,
                fontWeight: FontWeight.bold,
              ),
             ),
             ),
             const SizedBox(height: 10),
             RichText(
              text: const TextSpan(
                text: 'Having trouble logging in?',
                style: TextStyle(
                  color: Color.fromARGB(255, 172, 171, 171),
                ),
                children: [
                  TextSpan(
                    text: ' Get Help',
                    style: TextStyle(
                      color: Colors.blue,
                    )
                  )
                ]
                ),
             )
          ],
        ),
       ),
      ),
    );
  }
}