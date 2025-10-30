import 'package:flutter/material.dart';
import 'package:trip_plan/design/design.dart';
import 'package:trip_plan/globel/globel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  int _selectedIndex =-1;
  List<bool> isFav =[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFav = List.generate(trip.length, (index) => false,);


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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),
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
                      prefixIcon: Icon(
                        Icons.search,
                        color: const Color.fromARGB(255, 22, 27, 120),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: trip.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.37 / 3,
                ),
                itemBuilder: (context, index) {

                 
                  
                  return GestureDetector(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> Design()));
                    },
                    child: Card(
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
                                      image: NetworkImage(trip[index].imageurl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 128,
                                  top: 10,
                                  
                                  child:GestureDetector(
                                    onTap: () {
                                      setState(() { 
                                        isFav[index] =!isFav[index];
                                      });
                                    },
                    child: Icon(Icons.favorite,
                    color: isFav[index]? Colors.red:Colors.grey,),
                    
                                  )
                                ),
                                
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${trip[index].name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 17),
                                Expanded(child: Text("${trip[index].location}")),
                    
                                Icon(Icons.star, color: Colors.amber),
                                Text("4.5"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                    ),
                  );
                },
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: trip.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 225, 225, 225),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            trip[index].imageurl,
                            fit: BoxFit.cover,
                            height: 110,
                            width: 75,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8,),
                            child: Column(
                              children: [
                                Text("Awesome Place",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),),
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star,color: Colors.amber,size: 18,),
                                      Icon(Icons.star,color: Colors.amber,size: 18,),
                                      Icon(Icons.star,color: Colors.amber,size: 18,),
                                      Icon(Icons.star,color: Colors.amber,size: 18,),
                                      Icon(Icons.star,color: Colors.amber,size: 18,),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15,),
                                 Text("Go see the world \nthrough your own eyes.",style: TextStyle(
                            fontSize: 10
                          ),)
                              ],
                            ),
                            
                          ),
                          SizedBox(height: 10),
                         
                        ],
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
}
