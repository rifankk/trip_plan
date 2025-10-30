import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
       title: Padding(
         padding: const EdgeInsets.only(left: 90),
         child: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold),),
       ), 
     ),
     body: Center(
       child: Column(
        children: [
          CircleAvatar(
             child: Icon(Icons.person,size: 32,),
            radius: 50,
            
          ),
          SizedBox(height: 6),
          Text("Anil Das",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 22),),
          Text("anilkumar@gmail.com",style: TextStyle(fontSize: 14),),

          SizedBox(height: 10),
          
         
        ],
       ),
     ),
      );
  }
}