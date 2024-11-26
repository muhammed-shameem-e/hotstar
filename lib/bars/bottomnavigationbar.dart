import 'package:flutter/material.dart';
import 'package:hotstar/bars/tapBar.dart';
import 'package:hotstar/home_main_pages/downloads_page.dart';
import 'package:hotstar/home_main_pages/home_page.dart';
import 'package:hotstar/home_main_pages/my_space.dart';
import 'package:hotstar/home_main_pages/search_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentIndex = 0; // Track the current index
  final List<Widget> pages = [
    const Home(),
    Search(),
    const TapBarPage(),
    const Downloads(),
    const MySpace(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: currentIndex, // Set the current index
        onTap: (index) {
          setState(() {
            currentIndex = index; // Update the selected index
          });
        },
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        unselectedItemColor: const Color.fromARGB(255, 87, 87, 87),
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // No hardcoded color here
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // No hardcoded color here
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), // No hardcoded color here
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined), // No hardcoded color here
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined), // No hardcoded color here
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
