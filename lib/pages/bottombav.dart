import 'package:flutter/material.dart';
import 'package:trip_plan/homepage.dart';
import 'package:trip_plan/pages/explore.dart';
import 'package:trip_plan/pages/fav.dart';
import 'package:trip_plan/pages/profile.dart';

class Bottombav extends StatefulWidget {
  const Bottombav({super.key});

  @override
  State<Bottombav> createState() => _BottombavState();
}

class _BottombavState extends State<Bottombav> {
  late List<Widget> pages;

  late Homepage homepage;
  late Explore explore;
  late Fav fav;
  late Profile profile;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    homepage = const Homepage();
    explore = const Explore();
    fav = const Fav();
    profile = const Profile();
    pages = [homepage, explore, fav, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👇 shows the selected page
      body: pages[currentTabIndex],

      // 👇 bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      
    );
  }
}
