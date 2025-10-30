import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              leading:  Padding(
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
         title: Padding(
           padding: const EdgeInsets.only(left: 85),
           child: Text("Explore",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 22),),
         ),
            ),
             ListView.builder(
                  itemCount: 6,
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
                              "https://www.blizzard-tecnica.com/assets/images/stories/story-explore/story-explore-cover@2x.jpg",
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
           
          ],
        ),
      ),
    );
  }
}