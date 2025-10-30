import 'package:flutter/material.dart';
import 'package:trip_plan/design/booknow.dart';

class Design extends StatefulWidget {
  const Design({super.key});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new)),
        actions: [
         Padding(
           padding: const EdgeInsets.only(right: 20,bottom: 2),
           child: Icon(Icons.favorite_border_outlined,size: 32,),
         )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 360,
                width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Image.network("https://hblimg.mmtcdn.com/content/hubble/img/new_dest_imagemar/mmt/activities/m_Srinagar_4_l_800_1200.jpg",fit: BoxFit.cover,),),
              Padding(
                padding: const EdgeInsets.only(top: 320),
                child: Container(
                  height: 677,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 242, 242),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(28),topRight: Radius.circular(28))
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
                              return  Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                    height: 50,
                                    width: 95,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(image: NetworkImage("https://images.livemint.com/img/2023/01/14/original/mountain_environment_1673684710775.jpg"),fit: BoxFit.cover),
                                      color: const Color.fromARGB(255, 250, 250, 250)
                                    ),
                                 
                                  ),
                              );
                            },
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            child: Row(
                              children: [
                               
                               
                               Spacer(),
                                Icon(Icons.star,color: Colors.pink,),
                                Text("4.5",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),)
                              ],
                            ),
                          ),                         
                          
                          Row(
                            children: [
                               Icon(Icons.check_box,color: Colors.green,size: 23,),
                              Text("Sunset",style: TextStyle(fontSize: 18),),
                            ],
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Row(
                            children: [
                               Icon(Icons.check_box,color: Colors.green,size: 23,),
                              Text("Good food",style: TextStyle(fontSize: 18),),
                            ],
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Row(
                            children: [
                               Icon(Icons.check_box,color: Colors.green,size: 23,),
                              Text("Sunrise",style: TextStyle(fontSize: 18),),
                            ],
                          ),
                            SizedBox(
                              height: 20,
                            ),
        
                            Container(
                              height: 199,
                              width: 450,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 251, 252, 252),
                              ),
                                child: Image.network("https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg?mbid=social_retweet",fit: BoxFit.cover,),
                            ),
                      ],
                    ),
                  ),
                  
                ),
              ),
            ]
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
                            padding: const EdgeInsets.only(left: 20,top:10 ),
                            child: Row(
                              children: [
                                Container(
                                  height: 65,
                                  width: 65,
                                  
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage("https://media.istockphoto.com/id/483627817/photo/showing-off-his-pearly-whites.jpg?s=612x612&w=0&k=20&c=gk6aVVGp52YFx1ZzPVQplGc7JL5zkrfxQTuLjIn2RU8=",),  fit: BoxFit.cover),
                                  color: const Color.fromARGB(31, 37, 34, 34),
                                  borderRadius: BorderRadius.circular(18)
                                ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Resort Owner",style: TextStyle(
                                      fontSize: 15, color: const Color.fromARGB(255, 134, 133, 133)
                                    ),),
                                    Text("DavidMathew",style: TextStyle(
                                      fontSize: 19,fontWeight: FontWeight.w500
                                    ),)
                                  ],
                                ),
                                SizedBox(
                                  width: 120,
                                ),
                                CircleAvatar(radius: 25,backgroundColor: Colors.lightGreen,
                                child: Icon(Icons.call,color: Colors.white,size: 25,),
                                )
                              ],
                            ),
                          ),
            Padding(
                              padding: const EdgeInsets.all( 17),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Booknow()));
                                },
                                child: Container(
                                  height: 68,
                                  width: 400,
                                 decoration: 
                                 BoxDecoration( color: const Color.fromARGB(255, 41, 64, 75),
                                  borderRadius: BorderRadius.circular(20)
                                 ),
                                 child: Center(child: Text("Book Now",style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 245, 240, 240)
                                 ),)),
                                ),
                              ),
                            ),
          ],
        ),
      ),
    );
    
  }
}

