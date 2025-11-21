
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Authservice{
 
 final _auth = FirebaseAuth.instance;
 final _firestore = FirebaseFirestore.instance;

 Future <String> signup({
  String? username,
  String? email,
  String? password,
  
 })
 async{
  String res = "Some error occure";
  if(username!.isNotEmpty && email!.isNotEmpty && password!.isNotEmpty){
    UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection("User").doc(credential.user!.uid).set({
      'name':username,
      'email':email,
      'uid':credential.user!.uid,
    });
    res = "success";
  }
  else{
    res = "please fill all the field";
  }
  try{

  }catch(err){
    return err.toString();
  }
  return res;
 }


 Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    String? userid;
    String? message;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
         print("✅ Login successful!");
        userid = value.user?.uid;
        message = "Login Suucess";
      },);

     
    } on FirebaseAuthException catch (e) {
      print("❌ Firebase Auth error: ${e.code} - ${e.message}");
      message = 'Error ${e.message}';
      
    } catch (e) {
      print("❌ General error: $e");
        message = 'Login Failed';
    }finally {
        // ignore: control_flow_in_finally
        return {"uid":userid,"message":message};
    }
  }
 
}
