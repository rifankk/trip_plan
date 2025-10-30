import 'package:flutter/material.dart';

class Booknow extends StatefulWidget {
  const Booknow({super.key});

  @override
  State<Booknow> createState() => _BooknowState();
}

class _BooknowState extends State<Booknow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
       AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text("Bookings",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
        ),
      ),
    );
  }
}