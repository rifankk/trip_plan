import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trip_plan/design/design.dart';
import 'package:trip_plan/globel/globel.dart';

class PlacelistScreen extends StatefulWidget {
  PlacelistScreen({super.key, required this.mainplaceid});
  String mainplaceid;
  @override
  State<PlacelistScreen> createState() => _PlacelistScreenState();
}

class _PlacelistScreenState extends State<PlacelistScreen> {
  @override
  void initState() {
    log(widget.mainplaceid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: goamodel.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // two columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 4, // adjust tile size
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Design(imageurl: goamodel[index].imageurl),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(goamodel[index].imageurl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        goamodel[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
