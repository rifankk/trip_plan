import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:trip_plan/homepage.dart';
import 'package:trip_plan/pages/explore.dart';
import 'package:trip_plan/pages/fav.dart';
import 'package:trip_plan/pages/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurvedNavBarDemo(),
    );
  }
}

class CurvedNavBarDemo extends StatefulWidget {
  @override
  _CurvedNavBarDemoState createState() => _CurvedNavBarDemoState();
}

class _CurvedNavBarDemoState extends State<CurvedNavBarDemo> {
  int _index = 0;

  final screens = [
    Homepage(),
    Explore(),
    Fav(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      extendBody: true, // makes the curved effect look smoother
      body: screens[_index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.black,
        buttonBackgroundColor: Colors.red,
        height: 60,
        animationDuration: Duration(milliseconds: 400),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.explore, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
