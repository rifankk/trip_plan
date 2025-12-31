import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/Auth/authservice.dart';
import 'package:trip_plan/homepage.dart';

class Signup extends StatefulWidget {
   Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _userFormKey = GlobalKey<FormState>();


  final TextEditingController _userNameController =TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _useerPasswordController = TextEditingController();

  
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
                     Color.fromARGB(255, 169, 128, 113),
                     Color.fromARGB(255, 86, 168, 244),
                     Color.fromARGB(255, 5, 123, 234),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _userFormKey,
                  child: Column(
                    children: [
                       SizedBox(height: 130.h),
                       Icon(Icons.connecting_airports_outlined, size: 90),
                  
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                           Padding(
                      padding:  EdgeInsets.only(left: 20,),
                      child: Row(
                        children: [
                          Text("Sign",style: TextStyle(fontSize: 50,color: Colors.orange,fontWeight: FontWeight.bold),),
                          Text("In",style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),)
                      
                        ],
                      ),
                    ),
                         
                        ],
                      ),
                  
                       SizedBox(height: 50.h),
                  
                      // Username Field
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _userNameController,
                          decoration:  InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: "User Name",
                         
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your username";
                            } else if (value.length < 3) {
                              return "Username must be at least 3 characters";
                            }
                            return null;
                          },

                        ),
                      ),
                  
                       SizedBox(height: 25),
                  
                      // Email Field
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _userEmailController,
                          decoration:  InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            hintText: "Email",
                           
                          
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            // ✅ Email pattern validation
                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                          
                        ),
                      ),
                  
                       SizedBox(height: 25.h),
                  
                      // Password Field
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _useerPasswordController,
                          obscureText: true,
                          decoration:  InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password",
                          
                            
                          
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 25.h),
                       Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          obscureText: true,
                          decoration:  InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: " Comform Password",
                          
                            
                          
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            } else if (value !=
                                _useerPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                      ),
                  
                       SizedBox(height: 100.h),
                     GestureDetector(
                      onTap: () async{
                        if(_userFormKey.currentState!.validate()){
                          await Authservice().signup(email: _userEmailController.text,password: _useerPasswordController.text,username: _userNameController.text);
                          Navigator.pop(context);
                        }
                  
                                },
                                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  height: 45.h,width: 190.w,
                  
                  child: Center(child: Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                                ),
                              ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
