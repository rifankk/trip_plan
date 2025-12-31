import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/design/all_places.dart';
import 'package:trip_plan/design/design.dart';
import 'package:trip_plan/design/placelist_screen.dart';
import 'package:trip_plan/globel/globel.dart';
import 'package:trip_plan/model/banner_model%20.dart';
import 'package:trip_plan/model/hotel_model.dart';
import 'package:trip_plan/pages/booking_detail.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<bool> isFav = [];

  final List<String> imgList = [
    'https://picsum.photos/id/1018/600/400',
    'https://picsum.photos/id/1015/600/400',
    'https://picsum.photos/id/1016/600/400',
    'https://picsum.photos/id/1020/600/400',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFav = List.generate(trip.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CircleAvatar(radius: 20, child: Icon(Icons.person))),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Explore the world!",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here",
                      hintStyle: TextStyle(color: Colors.black45),
                      prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 22, 27, 120)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13.h),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('bannerslide').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading users"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No users found"));
                  }
                  final banners = snapshot.data!.docs;

                  List<Bannermodel> bannerList = banners
                      .map((doc) => Bannermodel.fromJson(doc.data() as Map<String, dynamic>))
                      .toList();
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 200.h,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                      aspectRatio: 16 / 9,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: bannerList.map((doc) {
                      final imageUrl = doc.image;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Design(placedtl: doc.place)),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Image.network(
                            imageUrl ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Icon(Icons.error));
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 5.h),

              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                width: double.infinity,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('MainPlace').snapshots(),
                  builder: (context, asyncSnapshot) {
                    return ListView.builder(
                      itemCount: asyncSnapshot.data?.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacelistScreen(
                                  mainplaceid: asyncSnapshot.data?.docs[index]['id'],
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.28,
                            width: 160.w,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 140.h,
                                          width: 190.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.r),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                asyncSnapshot.data?.docs[index]['image'] ??
                                                    "https://i.ytimg.com/vi/_e8BFrAPedM/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLB-LdzvAt6FPjdCrtillA_7P8ZVhg",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      asyncSnapshot.data?.docs[index]['place'] ?? 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: 3.h),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber),
                                        Text("4.5"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 13.w, right: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Explore More ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AllPlaces()),
                        );
                      },
                      child: Text(
                        "see all",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 11.h),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Places').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading places"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No places found"));
                  }

                  var places = snapshot.data!.docs;
                  int limit = places.length > 3 ? 3 : places.length;
                  final placesmodel = snapshot.data!.docs
                      .map((doc) => PlaceModel.fromJson(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: limit,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final place = placesmodel[index];
                      return Padding(
                        // Outer Padding/Margin
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Design(placedtl: place)),
                            );
                          },
                          child: Container(
                            // 1. Sleek Background and Shadow
                            decoration: BoxDecoration(
                              color: Colors.white, // Base color
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey.withOpacity(
                                    0.15,
                                  ), // Darker shadow for depth
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),

                            child: IntrinsicHeight(
                              // Ensures the Row children take up the full height
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // --- Image Section ---
                                  Container(
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.r),
                                        bottomLeft: Radius.circular(15.r),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage("${place.image}"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // --- Text Content Section ---
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(15.0.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // --- Top Section: Title and Rating ---
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Title
                                              Text(
                                                "${place.place}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900, // Extra Bold
                                                  fontSize: 18.sp,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                              SizedBox(height: 4.h),
                                            ],
                                          ),

                                          // --- Bottom Section: Description/Tagline and Action ---
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10.h),

                                              // Tagline/Description
                                              Text(
                                                "${place.description}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey[700],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                              SizedBox(height: 10.h),

                                              // Action Button/Indicator (using a subtle text button)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "View Details",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue[700],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 14.sp,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Container(
      child: CarouselSlider(
        items: [1, 2, 3, 4].map((i) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text("text$i", style: TextStyle(fontSize: 40.sp)),
            ),
          );
        }).toList(),
        options: CarouselOptions(height: 300.h),
      ),
    );
  }
}
