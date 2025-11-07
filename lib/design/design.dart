import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:trip_plan/design/booknow.dart';
import 'package:trip_plan/globel/globel.dart';

class Design extends StatefulWidget {
  final String? imageurl ;
  const Design({super.key,this.imageurl});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 2),
            child: Icon(Icons.favorite_border_outlined, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 360,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Image.network(
                 "${widget.imageurl}",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 320),
                  child: Container(
                    height: 600,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 242, 242),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          SizedBox(
                            height: 60,
                            width: 413,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 50,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "https://images.livemint.com/img/2023/01/14/original/mountain_environment_1673684710775.jpg",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      color: const Color.fromARGB(
                                        255,
                                        250,
                                        250,
                                        250,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 20),
                          Text(
                            "Itineray",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Day Wise Details of your package",
                            style: TextStyle(fontSize: 13),
                          ),

                          SizedBox(height: 12),
                          Row(
                            children: [
                              _iteneryContainer("Day Plan"),
                              _iteneryContainer(" Hotels"),
                              _iteneryContainer("Activities"),
                              _iteneryContainer("Meals"),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                "Day 1",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 9),
                              Text(
                                "Includes:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(" Hotel, Meals"),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 6),
                          Container(
                            height: 105,
                            width: double.infinity,

                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.business_outlined),
                                        SizedBox(width: 6),
                                        Text(
                                          "Resort",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        CircleAvatar(
                                          radius: 3,
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            73,
                                            72,
                                            72,
                                          ),
                                        ),
                                        SizedBox(width: 7),
                                        Text("2 Nights "),
                                        SizedBox(width: 5),
                                        CircleAvatar(
                                          radius: 3,
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            73,
                                            72,
                                            72,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text("In Goa"),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "The Tamarind Hotel\nAnjuna, Goa",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 11),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left:40,),
                                  child: Container(
                                    height: 170,width: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: NetworkImage("https://casadegoa.com/wp-content/uploads/2025/04/Image-8.webp",),fit: BoxFit.cover),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Text("Anjuna"),
                          SizedBox(height: 9),
                          Row(
                            children: [
                              Icon(Icons.access_time_outlined),
                              SizedBox(width: 5),
                              Text("6 December- 9 December, 3 Nights"),
                            ],
                          ),
                          SizedBox(height: 8,),
                          DottedLine(),
                          SizedBox(height: 12,),
                          Row(
                            children: [
                              Text("Day 2",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                              SizedBox(width: 8,),
                              Text("Includes:",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                              Text(" Hotel "),
                              CircleAvatar(radius: 3,backgroundColor: Colors.black,),
                              Text("  Meals  "),
                              CircleAvatar(radius: 3,backgroundColor: Colors.black,),
                              Text("  Activities"),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Icon(Icons.fastfood_outlined),
                              Text("  MEAL ",style: TextStyle(fontWeight: FontWeight.bold),),
                              CircleAvatar(radius: 3,backgroundColor: Colors.black,),
                              Text(" Breakfast  "),CircleAvatar(radius: 3,backgroundColor: Colors.black,),
                              Text("  In Goa")
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 4,),
                          Row(
                            children: [
                              Icon(Icons.sports_handball_rounded),
                              Text(" Activity ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              CircleAvatar(radius: 3,backgroundColor: Colors.black,),
                              Text(" 2 Hours "),CircleAvatar(radius: 3,backgroundColor: Colors.black,),
                              Text(" In Goa")
                            ],
                          ),
                          

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 200,
        width: 100,
        child: Column(
          children: [
            Divider(),

            Padding(
              padding: const EdgeInsets.all(17),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => booknow()),
                  );
                },
                child: Container(
                  height: 68,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 64, 75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 245, 240, 240),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iteneryContainer(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 35,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: Colors.white,
        ),
        child: Center(child: Text(name)),
      ),
    );
  }
}
