import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_plan/login.dart';
import 'package:trip_plan/splashpage.dart';

void main()async{
   WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  await Firebase.initializeApp();
  //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(Myapp());

}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800),
        minTextAdapt: true,            
      splitScreenMode: true, 

builder: (context, child) {
  return  MaterialApp(debugShowCheckedModeBanner: false,
    home: SplashPage(),
    );
},
    );
  }
}