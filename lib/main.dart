import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return MaterialApp(debugShowCheckedModeBanner: false,
    home: SplashPage(),
    );
  }
}