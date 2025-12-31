import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/homepage.dart';
import 'package:trip_plan/pages/booking_detail.dart';
import 'package:trip_plan/pages/favourite_screen.dart';
import 'package:trip_plan/pages/profile.dart';

class CurvedNavBarDemo extends StatefulWidget {
  @override
  _CurvedNavBarDemoState createState() => _CurvedNavBarDemoState();
}

class _CurvedNavBarDemoState extends State<CurvedNavBarDemo> {
  int _index = 0;

  final screens = [Homepage(), FavouriteScreen(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      extendBody: true, // makes the curved effect look smoother
      body: screens[_index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 64, 79, 165),
        buttonBackgroundColor: Colors.indigo,
        height: 60.h,
        animationDuration: Duration(milliseconds: 400),
        items: <Widget>[
          Icon(Icons.home, size: 26.sp, color: Colors.white),

          Icon(Icons.favorite, size: 26.sp, color: Colors.white),
          Icon(Icons.person, size: 26.sp, color: Colors.white),
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
