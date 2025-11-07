import 'package:flutter/material.dart';
import 'package:trip_plan/design/design.dart';
import 'package:trip_plan/globel/globel.dart';

class Goa extends StatefulWidget {
  const Goa({super.key});

  @override
  State<Goa> createState() => _GoaState();
}

class _GoaState extends State<Goa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goa"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            ListView.builder( 
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              itemCount: goamodel.length,
              
              itemBuilder:(context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Design(imageurl: goamodel[index].imageurl,)));
                      });
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,width: 390,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(11),
                               image: DecorationImage(image: NetworkImage(goamodel[index].imageurl),
                               fit: BoxFit.cover),
                              
                    
                            ),
                          ),
                          SizedBox(height: 9,),
                    
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(goamodel[index].name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                        ),
                          SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 3,backgroundColor: const Color.fromARGB(255, 100, 99, 99),),
                                SizedBox(width: 5,),
                                Text("3N Goa"),
                              ],
                            ),
                          ),
                        
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 3,backgroundColor: const Color.fromARGB(255, 84, 83, 83),),
                                SizedBox(width: 5,),
                                Text("4 Star Hotel")
                              ],
                            ),
                          ),
                       SizedBox(height: 6,),
                       Padding(
                         padding: const EdgeInsets.only(left: 12),
                         child: Row(
                           children: [
                             CircleAvatar(radius: 3,backgroundColor: const Color.fromARGB(255, 87, 87, 87),),
                             Text(" 1 Activities")
                           ],
                         ),
                       ),
                       SizedBox(height: 16,),
                    
                       Padding(
                         padding: const EdgeInsets.only(left: 10,right: 10),
                         child: Container(
                          height: 50,width: 350,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 206, 204, 204),
                            borderRadius: BorderRadius.circular(12),
                            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7,top: 15),
                            child: Row(
                              children: [
                                Text(" Per Person",style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(width: 155,),
                                Icon(Icons.currency_rupee_sharp,color: Colors.black,),
                                   Text("2999",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),)
                              ],
                            ),
                          ),
                         ),
                       ),
                       SizedBox(height: 6,),
                     
                        ],
                      ),
                    ),
                  ),
                );
              },)
          ],
        ),
      ),
    );
  }
}