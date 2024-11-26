import 'package:flutter/material.dart';
import 'package:hotstar/home_main_pages/hot_page.dart';
import 'package:hotstar/home_main_pages/new_page.dart';

class TapBarPage extends StatelessWidget {
  const TapBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor:  Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'Free - Newly Added',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                 child: Text(
                  'Coming Soon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
           NewPage(),
           HotPage(),
          ],
        ),
      ),
    );
  }
}