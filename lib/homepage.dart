import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trip_plan/design/placelist_screen.dart';
import 'package:trip_plan/globel/globel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 225, 225, 225),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.menu_open_sharp),
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 20),
        actions: [
          Container(
            height: 38,
            width: 40,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 225, 225, 225),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.notifications_on_sharp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Explore the world!",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.clear_all_sharp),
                      border: InputBorder.none,
                      hintText: "Search here",
                      hintStyle: TextStyle(color: Colors.black45),
                      prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 22, 27, 120)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13),

              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  aspectRatio: 16 / 9,
                  scrollDirection: Axis.horizontal,
                ),
                items: imgList.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(item, fit: BoxFit.cover, width: double.infinity),
                      );
                    },
                  );
                }).toList(),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Categories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
                ),
              ),
              SizedBox(height: 6),
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
                              MaterialPageRoute(builder: (context) => PlacelistScreen(mainplaceid: asyncSnapshot.data?.docs[index]['id'],)),
                            );
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.28,
                            width: 170,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 190,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                asyncSnapshot.data?.docs[index]['image'] ??
                                                    "https://i.ytimg.com/vi/_e8BFrAPedM/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLB-LdzvAt6FPjdCrtillA_7P8ZVhg",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,

                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isFav[index] = !isFav[index];
                                              });
                                            },
                                            child: Icon(
                                              Icons.favorite,
                                              color: isFav[index] ? Colors.red : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      asyncSnapshot.data?.docs[index]['place'] ?? 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        // Icon(Icons.location_on_outlined, size: 17),
                                        // Expanded(child: Text("${trip[index].location}")),
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
                padding: const EdgeInsets.only(left: 13, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Explore More ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      "see all",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 11),
              ListView.builder(
                itemCount: trip.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    // Outer Padding/Margin
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    child: Container(
                      // 1. Sleek Background and Shadow
                      decoration: BoxDecoration(
                        color: Colors.white, // Base color
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.15), // Darker shadow for depth
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
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
                              width: 100, // A bit wider for a better image preview
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(trip[index].imageurl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // --- Text Content Section ---
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween, // Distribute space
                                  children: [
                                    // --- Top Section: Title and Rating ---
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Title
                                        Text(
                                          "Awesome Place",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900, // Extra Bold
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        // Rating
                                        Row(
                                          children: [
                                            ...List.generate(
                                              5,
                                              (i) => Icon(
                                                i < 4
                                                    ? Icons.star
                                                    : Icons.star_border, // Example: 4 stars filled
                                                color: Colors.amber[700], // Deeper amber color
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "4.0 (25 Reviews)",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // --- Bottom Section: Description/Tagline and Action ---
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),

                                        // Tagline/Description
                                        Text(
                                          "Go see the world through your own eyes. Discover hidden gems.",
                                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 10),

                                        // Action Button/Indicator (using a subtle text button)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "View Details",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700],
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward,
                                              size: 14,
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
            child: Center(child: Text("text$i", style: TextStyle(fontSize: 40))),
          );
        }).toList(),
        options: CarouselOptions(height: 300),
      ),
    );
  }
}
