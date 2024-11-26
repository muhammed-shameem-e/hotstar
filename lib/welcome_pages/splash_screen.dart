import 'package:flutter/material.dart';
import 'package:hotstar/bars/bottomnavigationbar.dart';
import 'package:hotstar/home_main_pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    holding(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/splash.jpeg'),fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> holding(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> CustomBottomNavigationBar()));
  }
}