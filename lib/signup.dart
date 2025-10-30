import 'package:flutter/material.dart';
import 'package:trip_plan/homepage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.network(
              "https://images.unsplash.com/photo-1597407068889-782ba11fb621?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8ZGFyayUyMG1vdW50YWlufGVufDB8fDB8fHww&fm=jpg&q=60&w=3000",
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay
          Opacity(
            opacity: 0.7,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.brown,
                    const Color.fromARGB(255, 169, 128, 113),
                    const Color.fromARGB(255, 86, 168, 244),
                    const Color.fromARGB(255, 5, 123, 234),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 130),
                    const Icon(Icons.connecting_airports_outlined, size: 90),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                         Padding(
                    padding: const EdgeInsets.only(left: 20,),
                    child: Row(
                      children: [
                        Text("Sign",style: TextStyle(fontSize: 50,color: Colors.orange,fontWeight: FontWeight.bold),),
                        Text("In",style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),)
                    
                      ],
                    ),
                  ),
                       
                      ],
                    ),

                    const SizedBox(height: 50),

                    // Username Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "User Name",
                       
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Email Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Email",
                         
                        
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Password Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        obscureText: true,
                        decoration:  InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Password",
                        
                          
                        
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        obscureText: true,
                        decoration:  InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: " Comform Password",
                        
                          
                        
                        ),
                      ),
                    ),

                     SizedBox(height: 100,),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                ),
                height: 45,width: 190,
                
                child: Center(child: Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
              ),
            ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
